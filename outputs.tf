# Output the VPC ID
output "vpc_id" {
  value       = aws_vpc.intech_vpc.id
  description = "The ID of the VPC"
}

# Output the public IP address of the EC2 instance
output "ec2_public_ip" {
  value = aws_instance.intech_instance.public_ip
  description = "The public IP of the EC2 instance"
}


# Output the S3 bucket name
output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
  description = "The name of the S3 bucket"
}

# Output the DynamoDB table name
output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
  description = "The name of the DynamoDB table used for locking"
}
