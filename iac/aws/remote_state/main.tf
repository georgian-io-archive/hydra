terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.7"
    }
  }
}

provider "aws" {
  region  = "us-east-1"
}

resource "aws_s3_bucket" "terraform_remote_state" {
  bucket = var.remote_state_bucket_name
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_remote_state" {
  bucket                  = aws_s3_bucket.terraform_remote_state.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_dynamodb_table" "terraform_state_locks" {
  name           = var.remote_locks_dynamodb_name
  read_capacity  = var.remote_locks_read_capacity
  write_capacity = var.remote_locks_write_capacity
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

variable "remote_state_bucket_name" {
  description = "The name of the bucket that stores the remote state of a Terraform project"
  type        = string
}

variable "remote_locks_dynamodb_name" {
  description = "The name of the DynamoDB table that stores the remote locks of a Terraform project"
  type        = string
}

variable "remote_locks_read_capacity" {
  description = "The read capacity of the DynamoDB table that stores the remote locks of a Terraform project"
  type        = number
}

variable "remote_locks_write_capacity" {
  description = "The write capacity of the DynamoDB table that stores the remote locks of a Terraform project"
  type        = number
}