variable "region" {
  type        = string
  description = "AWS region for backend resources"
  default     = "eu-west-3"
}

variable "project" {
  type        = string
  description = "Project name for naming and tagging"
  default     = "terraform-infra"
}
