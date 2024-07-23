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

We can create resources from different providers and
use data from 1 resource inside another resource.

Terraform variables:
```terraform
#global variables located in variables.tf
variable "variables_sub_auto_ip" {
  description = "Set Automatic IP Assigment for Variables Subnet"
  type        = bool
  default = true
}
#local variables located at the top of the file, template
locals {
  # Block body
  local_variable_name = <EXPRESSION OR VALUE>
  local_variable_name = <EXPRESSION OR VALUE>
}
#example
locals {
  time = timestamp()
}
```






