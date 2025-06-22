# DevOps360 Terraform Infrastructure

This Terraform project provisions all AWS resources required for the DevOps360 application, following best practices for modularity, security, and maintainability.

## Directory Structure

```
devops360-terraform/
  main.tf                # Entry point, includes all modules/resources
  versions.tf            # Terraform and provider version constraints
  variables.tf           # Input variables for customization
  outputs.tf             # Outputs for integration and reference
  vpc.tf                 # VPC, subnets, and networking
  s3.tf                  # S3 bucket for file uploads
  dynamodb.tf            # DynamoDB table for user profiles
  cognito.tf             # Cognito user pool and app client
  secretsmanager.tf      # Secrets Manager for Cognito client secret
  ssm.tf                 # SSM Parameter Store integration for outputs
  README.md              # This file
```

## Resources Provisioned
- **VPC**: Isolated network for all resources
- **S3 Bucket**: For user file uploads and profile photos
- **DynamoDB Table**: For user profile data
- **Cognito User Pool & App Client**: For secure authentication
- **ECR Repository**: For storing container images
- **Secrets Manager Secret**: For storing the Cognito app client secret
- **SSM Parameter Store Parameters**: For storing all key outputs in a structured, IAM-friendly path

## SSM Parameter Store Integration
All important outputs (resource names, IDs, ARNs, etc.) are automatically stored in AWS SSM Parameter Store using a smart, hierarchical path structure:

```
/${project_name}/${environment}/<output_name>
```

For example:
- `/devops360/dev/s3_bucket_name`
- `/devops360/dev/dynamodb_table_name`
- `/devops360/dev/vpc_id`
- `/devops360/dev/public_subnet_id`
- `/devops360/dev/private_subnet_id`
- `/devops360/dev/cognito_user_pool_id`
- `/devops360/dev/cognito_user_pool_client_id`
- `/devops360/dev/cognito_client_secret_arn`
- `/devops360/dev/ecr_repository_url`

This structure makes it easy to grant IAM access to all parameters for a project or environment using a prefix (e.g., `/devops360/dev/*`).

### Retrieving Parameters
You can retrieve these parameters using the AWS CLI:

```bash
aws ssm get-parameter --name "/devops360/dev/s3_bucket_name" --query "Parameter.Value" --output text
```

Or from your application code using the AWS SDK.

## Secrets Manager: Cognito Client Secret
The Cognito app client secret is securely stored in AWS Secrets Manager. The secret name and deletion policy are configurable via variables:

- `cognito_secret_name`: Name for the secret (default: `devops360-dev-cognito-client-secret`).
- `cognito_secret_recovery_window_in_days`: Number of days before a deleted secret is permanently removed. **Set to `0` for immediate deletion in dev environments.**

### About `recovery_window_in_days`
- **In development:** Set `cognito_secret_recovery_window_in_days = 0` to allow immediate deletion and recreation of secrets. This is useful if you frequently run `terraform destroy` and `terraform apply`.
- **In production:** Use a value between `7` and `30` (AWS default is `7`). This gives you a window to recover secrets deleted by mistake.
- **Warning:** If you set this to `0`, deleted secrets are gone forever and cannot be recovered!

#### Example variable override for dev:
```hcl
cognito_secret_recovery_window_in_days = 0
```

#### Example variable override for prod:
```hcl
cognito_secret_recovery_window_in_days = 7
```

### Troubleshooting Secret Deletion Issues
- If you see an error like:
  > You can't create this secret because a secret with this name is already scheduled for deletion.

  This means AWS is still deleting a secret with that name. You must either:
  - Wait for the deletion period to finish (up to 7 days if not set to 0), **or**
  - Use a different secret name for now by overriding `cognito_secret_name`.

- If you need to re-use the same name quickly, always set `cognito_secret_recovery_window_in_days = 0` in dev.

## Usage
1. **Install Terraform:** [Terraform Downloads](https://www.terraform.io/downloads.html)
2. **Configure AWS credentials:**
   ```bash
   aws configure
   ```
3. **Initialize the project:**
   ```bash
   terraform init
   ```
4. **Review and customize variables:**
   - Edit `variables.tf` or provide a `terraform.tfvars` file to override defaults.
   - Key variables:
     - `aws_region`: AWS region to deploy resources
     - `project_name`: Project name prefix
     - `environment`: Deployment environment (dev, staging, prod)
     - `cognito_secret_name`: Name for the Cognito secret
     - `cognito_secret_recovery_window_in_days`: Secret deletion window
5. **Plan the deployment:**
   ```bash
   terraform plan
   ```
6. **Apply the changes:**
   ```bash
   terraform apply
   ```
7. **Destroy the infrastructure:**
   ```bash
   terraform destroy
   ```
   - In dev, secrets will be deleted immediately if `cognito_secret_recovery_window_in_days = 0`.

## Best Practices & Notes
- All resources are tagged for easy identification.
- Secrets are never hardcoded; the Cognito client secret is generated and stored securely.
- All key outputs are available in SSM Parameter Store for easy integration with other systems and pipelines.
- Use immediate secret deletion (`recovery_window_in_days = 0`) only in dev/test environments.
- For production, use a recovery window to protect against accidental deletion.
- For production, you can extend this project to include EKS, ArgoCD, and more.

---

**Start with `main.tf` and review each module for details.** 