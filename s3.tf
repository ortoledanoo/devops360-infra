# s3.tf
# Provisions an S3 bucket for user file uploads and profile photos.
# Includes versioning for data protection and public access blocking for security.

# S3 Bucket for uploads
resource "aws_s3_bucket" "uploads" {
  # Bucket name, dynamically set for project and environment
  bucket = "${var.project_name}-${var.environment}-uploads"
  # Allow bucket to be destroyed even if it contains objects (useful for dev/test)
  force_destroy = true

  # Tags for resource identification and cost allocation
  tags = {
    Name        = "${var.project_name}-uploads"
    Environment = var.environment
  }
}

# Enable versioning to protect against accidental deletion or overwrite
resource "aws_s3_bucket_versioning" "uploads" {
  bucket = aws_s3_bucket.uploads.id
  versioning_configuration {
    status = "Enabled" # Keep all versions of an object
  }
}

# Block all public access to the bucket for security
resource "aws_s3_bucket_public_access_block" "uploads" {
  bucket = aws_s3_bucket.uploads.id

  block_public_acls       = true  # Block public ACLs
  block_public_policy     = true  # Block public bucket policies
  ignore_public_acls      = true  # Ignore public ACLs
  restrict_public_buckets = true  # Restrict public access to the bucket
} 