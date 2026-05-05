terraform {
  required_version = ">= 1.8.0"

  backend "s3" {
    bucket         = "tfstate-terraform-infra-0d47477c"
    key            = "dev-eks/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks-terraform-infra"
    encrypt        = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-3"
}