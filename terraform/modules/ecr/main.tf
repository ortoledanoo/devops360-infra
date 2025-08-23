resource "aws_ecr_repository" "devops360-ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "IMMUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = var.kms_key_id != null ? "KMS" : "AES256"
    kms_key         = var.kms_key_id
  }
}

output "repository_url" {
  value = aws_ecr_repository.devops360-ecr.repository_url
} 