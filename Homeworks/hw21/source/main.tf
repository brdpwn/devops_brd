terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
    local = {
      source  = "hashicorp/local"
      version = ">= 2.4.0"
    }
    null = {
      source  = "hashicorp/null"
      version = ">= 3.2.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Ubuntu 22.04 LTS (Jammy) AMI by Canonical
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Use default VPC + its subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# SG for SSH(22) + HTTP(80)
resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-sg"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "All egress"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-sg"
  }
}

# AWS key pair from your local PUBLIC key
resource "aws_key_pair" "this" {
  key_name   = "${var.name_prefix}-key"
  public_key = file(var.public_key_path)
}

# Two EC2 instances
resource "aws_instance" "nginx" {
  count                       = var.instance_count
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = element(data.aws_subnets.default.ids, count.index % length(data.aws_subnets.default.ids))
  associate_public_ip_address = true
  key_name                    = aws_key_pair.this.key_name
  vpc_security_group_ids      = [aws_security_group.web.id]

  tags = {
    Name = "${var.name_prefix}-${count.index}"
  }
}

# Ensure ansible directory structure exists locally
resource "null_resource" "prep_ansible_dir" {
  provisioner "local-exec" {
    command = "mkdir -p ansible/templates"
  }
}

# Generate ansible/hosts.txt with group [nginx_hosts]
resource "local_file" "hosts_txt" {
  depends_on = [null_resource.prep_ansible_dir, aws_instance.nginx]

  filename = "${path.module}/ansible/hosts.txt"
  content = templatefile("${path.module}/ansible/templates/hosts.tpl", {
    ips = aws_instance.nginx[*].public_ip
  })
}

