# modules/s3/main.tf
# S3 module: Provisions an S3 bucket for uploads, with versioning and public access block.

resource "aws_s3_bucket" "uploads" {
  bucket        = var.bucket_name
  force_destroy = var.force_destroy
  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = var.versioning_status
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

output "bucket_name" {
  value = aws_s3_bucket.uploads.bucket
} 