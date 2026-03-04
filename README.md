# Terraform Infrastructure – AWS Dev Environment

## 📌 Overview
Infrastructure AWS complète déployée via Terraform :
- VPC multi-AZ
- Subnets public/private
- NAT Gateway
- EKS cluster
- Backend distant S3 + DynamoDB locking

## Architecture Overview

Infrastructure AWS organisée par environnement.

- bootstrap/: création backend distant (S3 + DynamoDB)
- envs/dev-vpc/: infrastructure réseau et compute
- modules/: modules Terraform réutilisables

## Design Decisions

- Séparation bootstrap / env pour éviter problème "poule/œuf".
- State distant pour collaboration.
- Subnets privés pour instances applicatives.
- NAT Gateway pour egress contrôlé.

## Real-world Issues Encountered

- Nodegroup CREATE_FAILED (instance non compatible Free Tier).
- State lock non libéré après crash Terraform.
- Service LoadBalancer <pending> sur Minikube.

## ⚙️ Infrastructure as Code
- Terraform modules
- Remote state (S3)
- State locking (DynamoDB)
- GitHub Actions CI (fmt/validate/plan)

## 🧠 Real-world incident
Nodegroup CREATE_FAILED (Free Tier incompatibility).
→ Debug via AWS CLI
→ Analyse health issues
→ Fix instance type
→ Re-apply

## 🚀 How to deploy
terraform init
terraform plan
terraform apply

```mermaid
graph TD
  Internet --> IGW
  IGW --> PublicSubnet
  PublicSubnet --> NAT
  NAT --> PrivateSubnet
  PrivateSubnet --> EKS
