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

variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.micro"]
}

variable "desired_size" {
  type    = number
  default = 2
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 3
}