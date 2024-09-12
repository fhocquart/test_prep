# Create an S3 bucket for Terraform state
resource "aws_s3_bucket" "terraform_state" {
  bucket = "femi-intech"  # Use the desired unique bucket name

  tags = {
    Name = "TerraformStateBucket"
  }
}

# Optionally create a DynamoDB table for state locking
resource "aws_dynamodb_table" "terraform_locks" {
  name         = "terraform-lock-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLocksTable"
  }
}
