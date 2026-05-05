# Terraform Infrastructure – AWS Dev Environment

Infrastructure as Code project built with Terraform to provision and manage AWS resources in a modular, environment-oriented layout.

The repository demonstrates a progressive infrastructure setup:

- remote Terraform state bootstrap with S3 and DynamoDB
- reusable Terraform modules
- isolated environments with independent state files
- AWS networking foundation for development
- EKS cluster definition on top of the VPC layer
- CI workflow for Terraform formatting, validation, and planning

## Architecture Overview

```text
terraform-infra/
+-- bootstrap/          # Remote state backend resources
+-- envs/
|   +-- dev/            # Simple local provider example
|   +-- prod/           # Terraform Cloud workspace example
|   +-- dev-vpc/        # AWS VPC, networking, bastion, private EC2
|   +-- dev-eks/        # EKS cluster using the dev VPC outputs
+-- modules/
|   +-- file/           # Reusable local_file module example
+-- aws-test/           # Minimal AWS provider test configuration
+-- .github/workflows/  # Terraform CI workflow
```

## Components

### Bootstrap

The `bootstrap` stack creates the shared backend used by the other Terraform environments:

- S3 bucket for remote state storage
- bucket versioning
- server-side encryption
- public access block
- DynamoDB table for state locking

This stack is intended to be applied first, before configuring the S3 backend in environment stacks.

### Development VPC

The `envs/dev-vpc` stack provisions a complete development network in `eu-west-3`:

- VPC with DNS support and hostnames enabled
- two public subnets across availability zones
- two private subnets across availability zones
- Internet Gateway for public routing
- NAT Gateway for private outbound traffic
- route tables and subnet associations
- bastion EC2 instance
- private EC2 test instance
- security groups for controlled SSH access
- IAM role and instance profile for scoped S3 read access

Key outputs from this stack include:

- `vpc_id`
- `public_subnet_ids`
- `private_subnet_ids`
- `bastion_public_ip`
- `private_test_ip`
- `nat_eip`

### Development EKS

The `envs/dev-eks` stack defines an Amazon EKS cluster using the VPC and private subnets created by `envs/dev-vpc`.

It includes:

- subnet tagging for Kubernetes load balancers
- EKS cluster creation through `terraform-aws-modules/eks/aws`
- public and private API endpoint access
- IRSA enabled
- AWS-managed add-ons:
  - CoreDNS
  - kube-proxy
  - VPC CNI
- managed node group configuration in private subnets

The stack also contains sample Kubernetes manifests:

- `nginx-deployment.yaml`
- `nginx-service.yaml`

## State Strategy

Each environment is designed to use its own Terraform state.

Current backend examples:

- `envs/dev`: S3 backend key `dev/terraform.tfstate`
- `envs/dev-vpc`: S3 backend key `dev-vpc/terraform.tfstate`
- `envs/dev-eks`: S3 backend key `dev-eks/terraform.tfstate`
- `envs/prod`: Terraform Cloud workspace named `prod`

This separation keeps environment changes isolated and makes plans easier to review.

The EKS stack reads the VPC outputs through `terraform_remote_state`, which keeps the networking and Kubernetes layers separated while still allowing explicit dependencies between stacks.

## CI Workflow

GitHub Actions runs Terraform checks on changes under `bootstrap/`, `envs/`, `modules/`, or the workflow itself.

The workflow currently performs:

- repository-wide `terraform fmt -check -recursive`
- `terraform init` and `terraform validate` for:
  - `bootstrap`
  - `envs/dev-vpc`
  - `envs/dev-eks`
- `terraform plan` for `envs/dev-vpc`
- plan artifact upload
- plan comment on pull requests

## Usage

### 1. Bootstrap the remote state

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

Use the generated S3 bucket and DynamoDB table values to configure environment backends.

### 2. Deploy the development VPC

```bash
cd envs/dev-vpc
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

### 3. Deploy the development EKS cluster

The EKS stack reads the VPC outputs from the `dev-vpc` remote state.

```bash
cd envs/dev-eks
terraform init
terraform plan -var-file="dev.tfvars"
terraform apply -var-file="dev.tfvars"
```

After the cluster is available, configure `kubectl` with AWS:

```bash
aws eks update-kubeconfig --region eu-west-3 --name dev-eks
```

Then deploy the sample NGINX workload:

```bash
kubectl apply -f nginx-deployment.yaml
kubectl apply -f nginx-service.yaml
```

## Requirements

- Terraform 1.8+
- AWS account and credentials
- AWS CLI
- kubectl for EKS workload deployment

## Configuration Examples

Example variable files are provided as starting points:

- `envs/dev-vpc/dev.tfvars.example`
- `envs/dev-eks/dev.tfvars.example`

Copy the relevant example to `dev.tfvars` and adjust environment-specific values before applying.

## Notes

- The project uses `eu-west-3` as the default AWS region.
- The VPC layer should be applied before the EKS layer.
- EKS node groups are configured with small instance types by default for a lightweight development setup.
- Remote state must exist before S3-backed environments can be initialized successfully.
