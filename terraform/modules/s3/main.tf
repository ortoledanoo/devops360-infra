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
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket                  = aws_s3_bucket.uploads.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = var.kms_key_id != null ? "aws:kms" : "AES256"
      kms_master_key_id = var.kms_key_id
    }
  }
}

resource "aws_s3_bucket_logging" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  target_bucket = aws_s3_bucket.uploads.id
  target_prefix = "logs/"
}

output "bucket_name" {
  value = aws_s3_bucket.uploads.bucket
} 