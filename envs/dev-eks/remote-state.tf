data "terraform_remote_state" "dev_vpc" {
  backend = "s3"

  config = {
    bucket         = var.vpc_state_bucket
    key            = var.vpc_state_key
    region         = var.vpc_state_region
    dynamodb_table = var.vpc_state_lock_table
    encrypt        = true
  }
}
