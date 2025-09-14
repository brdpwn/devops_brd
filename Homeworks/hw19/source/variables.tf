variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-central-1" # Frankfurt (close to UA). Change if needed.
}

variable "project" {
  description = "Name prefix for all resources"
  type        = string
  default     = "tf-vpc-lab"
}

variable "vpc_cidr" {
  description = "VPC CIDR"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet CIDR"
  type        = string
  default     = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  description = "Private subnet CIDR"
  type        = string
  default     = "10.0.2.0/24"
}

variable "my_ip_cidr" {
  description = "Your public IP with /32 for SSH to bastion (e.g., 1.2.3.4/32). Use 0.0.0.0/0 only for quick tests."
  type        = string
}

variable "public_key_path" {
  description = "Path to your SSH public key (e.g., ~/.ssh/id_rsa.pub)"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ec2_ami_name_filter" {
  description = "AMI filter for Amazon Linux 2023"
  type        = string
  default     = "al2023-ami-*-x86_64"
}

