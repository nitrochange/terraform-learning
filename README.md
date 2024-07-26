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

Terraform data blocks:
The way to combine to load of query some data
Use provider documentation here.
```terraform
data <data-type> <data-name> {
        <identifier> = <expression>
}
#see examples in the code
data "aws_availability_zones" "available" {}
```
Эта data вытаскивает из aws переменную типа aws_availability_zones и из нее мы может вытащить 
переменные которые находятся внутри этого блока.
```terraform
data "aws_ami" "ubuntu" {
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
```
data может содержать фильтры
Terraform configuration
We can use terraform.tf to configure out local terraform

Terraform modules:
Ways to organize our infrastructure into logical folders. Modules can be online or offline
```shell
module "<module-name>" {
  source = <module-source>
  <input_name> = <description>
  <input_name> = <description>
}
```

Terraform output:
If we want to see some output variables after our deploy we can use:
```terraform
terraform output
terraform output --json
```
Terraform provioners:
There are two types of provisioners, local performs some tasks on local machine.
Remote provisioner executes commands on remote target, examples:
```terraform
#changes permissions for local key
provisioner "local-exec" {
    command = "chmod 600 ${local_file.private_key_pem.filename}"
  }
# performs commands on remote target
provisioner "remote-exec" {
  inline = [
    "sudo rm -rf /tmp",
    "sudo git clone https://github.com/hashicorp/demo-terraform-101 /tmp",
    "sudo sh /tmp/assets/setup-web.sh",
  ]
}
```







