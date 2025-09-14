variable "vpc_id" {
  type        = string
  description = "VPC ID to place resources in"
}

variable "list_of_open_ports" {
  type        = list(number)
  description = "Ports to open to 0.0.0.0/0"
}

variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "name_prefix" {
  type        = string
  default     = "danit-nginx"
}

variable "subnet_id" {
  description = "If set, use this existing subnet (must be public). When null, module creates one."
  type        = string
  default     = null
}

