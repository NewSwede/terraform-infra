terraform {
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
  content  = "Hello from dev environment"
}
