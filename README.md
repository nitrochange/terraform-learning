# terraform-learning
Repository contains code samples completed during terraform course

```
export AWS_ACCESS_KEY_ID="..."
export AWS_SECRET_ACCESS_KEY="..."
terraform init
terraform plan --auto-approve
terraform apply --autp-approve
```

Since terraform requires access for state file if collaborative approach.
Common approach is to have state file in S3 or in some common remote machine.

```
#shows state
terraform show
#format code
terraform fmt
#show all managed resources
terraform state list
```

## Basics of Terraform
Basic lifecycle.
```terraform
terraform apply
terraform validate
terraform init
terraform plan
terraform apply
terraform destroy
```

HCL syntax:
```terraform
<BLOCK TYPE> "<BLOCK LABEL>" "<BLOCK LABEL>" {
        identifier = expression
} 
```
Terraform providers:
used to interact with Cloud Platforms
```terraform
terraform version
terraform providers
```

Terraform resources:
One or more deployed resource








