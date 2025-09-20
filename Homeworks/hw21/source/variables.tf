variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}

variable "instance_count" {
  type    = number
  default = 2
}

variable "allowed_ssh_cidr" {
  type    = string
  default = "0.0.0.0/0" # tighten to your IP/CIDR
}

variable "name_prefix" {
  type    = string
  default = "nginx-host"
}

variable "public_key_path" {
  description = "Path to your SSH PUBLIC key (for AWS key pair)"
  type        = string
}

