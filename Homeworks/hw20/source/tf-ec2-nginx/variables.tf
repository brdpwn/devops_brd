variable "login_name" {
  description = "Your unique login to build the S3 state key path"
  type        = string
}

variable "vpc_id" {
  description = "Target VPC where the instance and SG will live"
  type        = string
}

variable "list_of_open_ports" {
  description = "Ports to open to the world in the created security group"
  type        = list(number)
  default     = [80] # nginx
}

# Optional: instance size & name
variable "instance_type" {
  type        = string
  default     = "t3.micro"
}

variable "name_prefix" {
  type        = string
  default     = "danit-nginx"
}

