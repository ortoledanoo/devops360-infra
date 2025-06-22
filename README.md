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
  README.md              # This file
```

## Resources Provisioned
- **VPC**: Isolated network for all resources
- **S3 Bucket**: For user file uploads and profile photos
- **DynamoDB Table**: For user profile data
- **Cognito User Pool & App Client**: For secure authentication
- **Secrets Manager Secret**: For storing the Cognito app client secret

## Usage
1. Install [Terraform](https://www.terraform.io/downloads.html)
2. Configure your AWS CLI credentials (`aws configure`)
3. Initialize the project:
   ```bash
   terraform init
   ```
4. Review and customize variables in `variables.tf` as needed
5. Plan the deployment:
   ```bash
   terraform plan
   ```
6. Apply the changes:
   ```bash
   terraform apply
   ```

## Notes
- All resources are tagged for easy identification.
- Secrets are never hardcoded; the Cognito client secret is generated and stored securely.
- For production, you can extend this project to include EKS, ArgoCD, and more.

---

**Start with `main.tf` and review each module for details.** 