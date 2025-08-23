# modules/secretsmanager/main.tf
# Secrets Manager module: Provisions a secret and its value for secure storage.

resource "aws_secretsmanager_secret" "this" {
  name                    = var.name
  recovery_window_in_days = var.recovery_window_in_days
  description             = var.description
  kms_key_id              = var.kms_key_id
  tags                    = var.tags
}

resource "aws_secretsmanager_secret_version" "this" {
  secret_id     = aws_secretsmanager_secret.this.id
  secret_string = var.secret_string
}

output "secret_arn" {
  value = aws_secretsmanager_secret.this.arn
} 