# DevOps360 Terraform Infrastructure

Terraform project that provisions all AWS infrastructure for the DevOps360 application, including an EKS cluster for running workloads, designed with best practices in modularity, security, and maintainability.


## Directory Structure

```
/devops360-infra
├── envs
│   ├── dev
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   └── variables.tf
│   └── prod
│       ├── backend.tf
│       ├── main.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       └── variables.tf
├── modules
│   ├── alb
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── cognito
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── dynamodb
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── ecr
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── eks
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── k8s-app
│   │   ├── main.tf
│   │   ├── manifests
│   │   │   └── weather-app.yaml
│   │   ├── outputs.tf
│   │   ├── service-account.tf
│   │   └── variables.tf
│   ├── s3
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── secretsmanager
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── ssm
│   │   ├── main.tf
│   │   └── variables.tf
│   └── vpc
│       ├── main.tf
│       └── variables.tf
└── README.md
```

## Usage
1. **Install Terraform:** [Terraform Official Install docs](terraform)

2. **Configure AWS credentials:**
   ```bash
   aws configure
   ```
3. **Initialize the project:**
   ```bash
   terraform init
   ```
4. **Review and customize variables:**
   - Edit `terraform.tfvars` file according to your project.
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
