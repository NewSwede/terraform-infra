# Terraform Infrastructure – AWS Dev Environment

## 📌 Overview
Infrastructure AWS complète déployée via Terraform :
- VPC multi-AZ
- Subnets public/private
- NAT Gateway
- EKS cluster
- Backend distant S3 + DynamoDB locking

## 🏗 Architecture
(Diagramme ici)

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
