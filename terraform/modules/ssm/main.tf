# modules/ssm/main.tf
# SSM module: Provisions an SSM Parameter Store parameter for sharing config or output values.

resource "aws_ssm_parameter" "this" {
  name  = var.name
  type  = var.type
  value = var.value
  tags  = var.tags
} 