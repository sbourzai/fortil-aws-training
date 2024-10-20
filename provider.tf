
terraform {
  backend "s3" {
    bucket = "aws-training-terraform-states"
    region = "eu-west-1"
    key    = "first-vpc/terraform.tfstate"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.52.0"
    }
  }
}

provider "aws" {
  region = "eu-west-1"
}

provider "aws" {
  region = "us-east-1"
  alias = "america"
}

provider "archive" {}
