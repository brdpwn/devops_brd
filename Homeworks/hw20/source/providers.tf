terraform {
  required_version = ">= 1.6.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
  }

  backend "s3" {
    bucket = "terraform-state-danit-devops-9"
    region = "eu-central-1"
    # DO NOT put 'key' here if you want it to be dynamic
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}

