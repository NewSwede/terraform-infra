# trigger second run

terraform {
  cloud {
    organization = "sylva-devops"

    workspaces {
      name = "dev"
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
  filename = "dev.txt"
  content  = "Hello v2 from dev environment"
}
