output "tfstate_bucket" {
  value       = aws_s3_bucket.tfstate.bucket
  description = "S3 bucket where Terraform state will be stored"
}

output "lock_table" {
  value       = aws_dynamodb_table.locks.name
  description = "DynamoDB table used for state locking"
}
