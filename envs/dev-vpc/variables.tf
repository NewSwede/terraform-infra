variable "my_ip_cidr" {
  type        = string
  description = "Your public IP in CIDR (/32) for SSH access to bastion."
}

variable "state_bucket_name" {
  type        = string
  description = "S3 bucket name used for remote state (demo target for IAM access)."
  default     = "tfstate-terraform-infra-0d47477c"
}

variable "state_bucket_prefix" {
  type        = string
  description = "Prefix inside the bucket that the instance is allowed to read."
  default     = "dev-vpc/"
}
