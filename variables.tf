# Define the AWS region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Define the VPC CIDR block
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

# Define the public subnet CIDR block
variable "public_subnet_cidr" {
  description = "The CIDR block for the public subnet"
  type        = string
  default     = "10.0.1.0/24"
}

# Define the EC2 instance type
variable "instance_type" {
  default = "t2.micro"  # Change to a smaller instance type
}

# Define the key pair name
variable "key_pair" {
  description = "The key pair name to use for EC2 instances"
  type        = string
  default     = "CM_keypair"
}
