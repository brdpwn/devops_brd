# Import / create key in AWS from your local public key
resource "aws_key_pair" "lab_key" {
  key_name   = "${var.project}-key"
  public_key = file(var.public_key_path)
}

# SG for Bastion (public EC2): allow SSH only from your IP
resource "aws_security_group" "bastion_sg" {
  name        = "${var.project}-bastion-sg"
  description = "Allow SSH from my IP"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH from my IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.my_ip_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-bastion-sg" }
}

# SG for Private EC2: allow SSH only from Bastion SG
resource "aws_security_group" "private_sg" {
  name        = "${var.project}-private-sg"
  description = "Allow SSH only from bastion"
  vpc_id      = aws_vpc.main.id

  ingress {
    description     = "SSH from bastion"
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  # allow all egress (needed for outbound to NAT for ping, updates)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "${var.project}-private-sg" }
}

# Bastion / Public EC2
resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.lab_key.key_name

  tags = {
    Name = "${var.project}-bastion"
    Role = "bastion"
  }

  user_data = <<-EOF
    #!/usr/bin/bash
    set -euxo pipefail
    dnf -y update || true
    dnf -y install iputils bind-utils telnet
  EOF
}

# Private EC2
resource "aws_instance" "private" {
  ami                         = data.aws_ami.al2023.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.private_sg.id]
  key_name                    = aws_key_pair.lab_key.key_name
  associate_public_ip_address = false

  tags = {
    Name = "${var.project}-private"
    Role = "private"
  }

  user_data = <<-EOF
    #!/usr/bin/bash
    set -euxo pipefail
    dnf -y update || true
    dnf -y install iputils bind-utils
  EOF
}

