############################################
# Data
############################################
data "aws_vpc" "this" {
  id = var.vpc_id
}

# Only needed if we create a subnet (to route 0.0.0.0/0)
data "aws_internet_gateway" "igw" {
  count = var.subnet_id == null ? 1 : 0
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

############################################
# Optional: create a brand-new public subnet
############################################
# Pick a slice index unlikely to collide with default VPC subnets.
# If it still collides, change 200 to 201/202/etc.
resource "aws_subnet" "public" {
  count                   = var.subnet_id == null ? 1 : 0
  vpc_id                  = var.vpc_id
  cidr_block              = cidrsubnet(data.aws_vpc.this.cidr_block, 8, 200)
  map_public_ip_on_launch = true

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

resource "aws_route_table" "public" {
  count  = var.subnet_id == null ? 1 : 0
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-rt-public"
  }
}

resource "aws_route" "default_inet" {
  count                  = var.subnet_id == null ? 1 : 0
  route_table_id         = aws_route_table.public[0].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = data.aws_internet_gateway.igw[0].id
}

resource "aws_route_table_association" "public_assoc" {
  count         = var.subnet_id == null ? 1 : 0
  subnet_id     = aws_subnet.public[0].id
  route_table_id= aws_route_table.public[0].id
}

############################################
# Choose which subnet we'll actually use
############################################
locals {
  effective_subnet_id = var.subnet_id != null ? var.subnet_id : aws_subnet.public[0].id
}

############################################
# Security Group (open selected ports)
############################################
resource "aws_security_group" "web" {
  name        = "${var.name_prefix}-sg"
  description = "Allow selected ports from anywhere"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = toset(var.list_of_open_ports)
    content {
      description      = "Open port ${ingress.value}"
      from_port        = ingress.value
      to_port          = ingress.value
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = ["::/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = { Name = "${var.name_prefix}-sg" }
}

############################################
# AMI & User data (Nginx via APT)
############################################
data "aws_ami" "ubuntu_2404" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

locals {
  user_data = <<-EOF
    #!/usr/bin/env bash
    set -euxo pipefail
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y nginx
    systemctl enable nginx
    systemctl restart nginx
    echo "<h1>It works! $(hostname)</h1>" > /var/www/html/index.nginx-debian.html
  EOF
}

############################################
# EC2 Instance
############################################
resource "aws_instance" "web" {
  ami                         = data.aws_ami.ubuntu_2404.id
  instance_type               = var.instance_type
  subnet_id                   = local.effective_subnet_id
  vpc_security_group_ids      = [aws_security_group.web.id]
  associate_public_ip_address = true
  user_data                   = local.user_data

  tags = {
    Name = "${var.name_prefix}-ec2"
  }
}

