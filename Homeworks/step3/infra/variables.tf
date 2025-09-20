variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "private_subnet_cidr" {
  type    = string
  default = "10.0.2.0/24"
}

variable "allowed_ssh_cidr" {
  type        = string
  description = "Your IP/CIDR allowed to SSH the master"
  default     = "0.0.0.0/0"
}

variable "master_instance_type" {
  type    = string
  default = "t3.small"
}

variable "worker_instance_type" {
  type    = string
  default = "t3.small"
}

variable "public_key_path" {
  type        = string
  description = "Path to your local SSH PUBLIC key (e.g., ~/.ssh/id_ed25519.pub)"
}

