terraform {
  backend "s3" {
    bucket         = "tfstate-terraform-infra-0d47477c"
    key            = "dev/terraform.tfstate"
    region         = "eu-west-3"
    dynamodb_table = "terraform-locks-terraform-infra"
    encrypt        = true
  }

  required_providers {
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
}

provider "local" {}

module "file_example" {
  source   = "../../modules/file"
  filename = "dev.txt"
  content  = "Hello v2 from dev environment"
}
