locals {
  tags = {
    Project     = var.project
    Environment = var.env
  }
}

# --- Subnet tags (EKS + Load Balancers) ---
# Public subnets: for internet-facing load balancers
resource "aws_ec2_tag" "public_subnet_cluster" {
  for_each    = toset(var.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "public_subnet_role_elb" {
  for_each    = toset(var.public_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

# Private subnets: for internal load balancers and nodes
resource "aws_ec2_tag" "private_subnet_cluster" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}

resource "aws_ec2_tag" "private_subnet_role_internal_elb" {
  for_each    = toset(var.private_subnet_ids)
  resource_id = each.value
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.29"

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnet_ids

  # Endpoint access: start simple (public), later we can harden to private-only
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  enable_irsa = true

  # Managed add-ons (AWS-managed)
  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni    = {}
  }

  # Node group in private subnets
  eks_managed_node_groups = {
    default = {
      subnet_ids = var.private_subnet_ids

      instance_types = var.node_instance_types
      min_size       = var.min_size
      max_size       = var.max_size
      desired_size   = var.desired_size

      # Security baseline (simple)
      ami_type       = "AL2_x86_64"
      capacity_type  = "ON_DEMAND"

      tags = local.tags
    }
  }

  tags = local.tags
}