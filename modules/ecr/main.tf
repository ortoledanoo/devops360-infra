resource "aws_ecr_repository" "devops360-ecr" {
  name                 = var.ecr_name
  image_tag_mutability = "MUTABLE"
  force_delete         = true

  image_scanning_configuration {
    scan_on_push = true
  }
}

output "repository_url" {
  value = aws_ecr_repository.devops360-ecr.repository_url
} 