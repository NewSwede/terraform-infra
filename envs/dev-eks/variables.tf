variable "project" {
  type    = string
  default = "terraform-infra"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "cluster_name" {
  type    = string
  default = "dev-eks"
}

variable "cluster_version" {
  type        = string
  description = "Kubernetes version for the EKS control plane."
  default     = "1.29"
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  description = "CIDR blocks allowed to reach the public EKS API endpoint."
  default     = ["0.0.0.0/0"]
}

variable "vpc_state_bucket" {
  type        = string
  description = "S3 bucket containing the dev-vpc Terraform state."
  default     = "tfstate-terraform-infra-0d47477c"
}

variable "vpc_state_key" {
  type        = string
  description = "S3 object key for the dev-vpc Terraform state."
  default     = "dev-vpc/terraform.tfstate"
}

variable "vpc_state_region" {
  type        = string
  description = "AWS region of the dev-vpc Terraform state bucket."
  default     = "eu-west-3"
}

variable "vpc_state_lock_table" {
  type        = string
  description = "DynamoDB table used to lock the dev-vpc Terraform state."
  default     = "terraform-locks-terraform-infra"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.micro", "t2.micro"]
}

variable "desired_size" {
  type    = number
  default = 0
}

variable "min_size" {
  type    = number
  default = 0
}

variable "max_size" {
  type    = number
  default = 1
}
