terraform {
  cloud {
    organization = "sylva-devops"

    workspaces {
      name = "prod"
    }
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
  filename = "prod.txt"
  content  = "Hello from prod environment"
}
