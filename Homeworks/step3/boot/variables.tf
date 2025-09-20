variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "bucket_name" {
  type        = string
  description = "Globally-unique S3 bucket name for Terraform state"
}

variable "dynamodb_table_name" {
  type    = string
  default = "terraform-locks"
}

