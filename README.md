# terraform-learning
Repository contains code samples completed during terraform course

github with labs:
https://github.com/btkrausen/hashicorp/tree/master/terraform/Hands-On%20Labs

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
The way retrieve some information with api (provider api will be used)
Use provider documentation here. For example here
we create data block with type:`aws_availability_zones` and
local name: `available`, later we can query retrieved data with:
`data.aws_availability_zones.available.<some-data>`
```terraform
data <type> <local-name> {
        <identifier> = <expression>
}

#query
data.<type>.<local-name>.<attribute>        

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

### Terraform modules:
Ways to organize our infrastructure into logical folders. Modules can be online or offline
```shell
module "<module-name>" {
  source = <module-source>
  <input_name> = <description>
  <input_name> = <description>
}
```

### Terraform output:
If we want to see some output variables after our deploy we can use:
```terraform
terraform output
terraform output --json
```
### Terraform providers:
Local provider is responsible for managing local resources such as files. 
```terraform
terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}
```
`tf providers` - command to check installed providers

`tf init -upgrade` - initiate terraform and upgrade all providers

### Terraform provisioners:
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
Terraform taint and replace
`taint` - manually mark resource for recreation. 
Simple way to redeploy only marked resources, not all managed by terraform.
```terraform
terraform state list
terraform taint <resource.name>
terraform plan
terraform apply
```
Example showing recreation only 1 of resources.
`Taint` - is deprecated how recommended approach is --replace command.
```terraform
terraform apply -replace="aws_instance.web_server"
```
Terraform import:
There is a way to connect already existing resources to terraform and manage their state.
Command to use:
```terraform
terraform import <resource_type>.<resource_name> <existing_resource_id>
#example
terraform import aws_instance.aws_linux i-0bfff5070c5fb87b6
```
After that unfortunatelly we have to manually copy some parameters into `main.tf` file, not sure why?

Terraform workspaces:
Cool feature, allows distinguish resources that we are creating in several workspaces
```terraform
terraform workspace new <name>
terraform workspace select <name>
```
Terraform state CLI:
There are some commands that can help track some states more flexibly
```terraform
terraform state show <resource_type>.<resource_name>
terraform state list
```
Debugging Terraform:
We can choose log level and put all logs into log file.
```terraform
#Logging level
export TF_LOG=TRACE
#logging file
export TF_LOG_PATH="terraform_log.txt"
#disable logging
export TF_LOG=""
```

### Terraform modules
Terraform modules are basically folder that contains some code, nothing more.
Terraform can use local modules, modules from Terraform public registry and modules from private
registry(Terraform Cloud, Terraform Enterprise).
Local modules:
```terraform
|-- modules
|     |-- server
|           |-- server.tf
|     |-- web_server
|           |-- server.tf
|
```
In that case we will need to reference local code from root module:
```terraform
module "server_subnet_1" {
  source      = "./modules/web_server"
  ...
}
```
Terraform public registry:
```terraform
module "autoscaling" {
  source = "terraform-aws-modules/autoscaling/aws"
  ...
}
```
After every change in modules we want to run `terraform init`
Modules Structure:
```terraform
|-- modules
|     |-- server
|           |-- main.tf
|           |-- variables.tf
|           |-- outputs.tf
|     |-- web_server
|           |-- main.tf
|           |-- variables.tf
|           |-- outputs.tf
|
```
`variables.tf` will contain the variable definitions for your module. When your module is used by others, 
the variables will be configured as arguments in the module block. Since all Terraform values must be defined, 
any variables that are not given a default value will become required arguments. 
Variables with default values can also be provided as module arguments, overriding the default value.

We can use outputs from module in different modules(like input and output variables).

Some guidelines to create a good module:
1. Encapsulation: Group infrastructure that is always deployed together. Including more infrastructure in a module makes it easier for an end user to deploy that infrastructure but makes the module's purpose and requirements harder to understand
2. Privileges: Restrict modules to privilege boundaries. If infrastructure in the module is the responsibility of more than one group, using that module could accidentally violate segregation of duties. Only group resources within privilege boundaries to increase infrastructure segregation and secure your infrastructure
3. Volatility: Separate long-lived infrastructure from short-lived. For example, database infrastructure is relatively static while teams could deploy application servers multiple times a day. Managing database infrastructure in the same module as application servers exposes infrastructure that stores state to unnecessary churn and risk.

modules have versions.
we can set version expliciltly or write some constraints for versions

## Core Terraform workflow
### Terraform init
`terraform init` - command is used to initialize a working directory containing Terraform 
configuration files. This is the first command that should be run after writing a new Terraform configuration or cloning an existing one from version control.
By default terraform find, download and install providers from public registry, if we don't 
want such behaviour we can customize it in configuration.
If we want to change the directory where we track state we can add following configuration 
to our `terraform.tf` file:
```terraform
  backend "local" {
    path = "mystate/terraform.tfstate"
  }
```
then, to apply our changes:
```bash
terraform init --migrate-state
```
Validation of terraform configuration:
`terraform validate` - ensures that all configuration is correct
`terraform validate -json` - useful in pipelines, to see|publish errors

### Terraform plan
`terraform plan` - dry-run of your changes and checking and outgoing result
matched your expectations. Also this command checks current state and identifies 
differences between existing infrastructure and written infrastructure.
```bash
terraform plan
terraform plan -out file
terraform plan -refresh-only
```
### Terraform apply
`terraform apply` - executes promised actions on actual infrastructure.
```bash
terraform apply
#also we can apply from the saved plan
terraform apply myplan
```
## Terraform State Management
`terraform apply` - performs a lock while applying, so 1 one user can `apply` at the same time
we can specify timeout if we want
`terraform apply -lock-timeout=60s`
Not all backends supports locking(which is obviously important for collaborative teams). 
Remote state(Terraform Cloud, Terraform Enterprise) supports locking. Default backend `local` 
supports locking.

### State authentication
Since we have some state in remote and several people have access to that state 
we need to create some permissions control because we dont want everyone to access our state.
We configured default S3 state backend in our labs.

### State Locks
To prevents concurrent modifications of our remote-state we are using Dynamo-DB table,
first of all we have to configure it manually and then provide value of that DynamoDB to our
terraform backend configuration

### State Migration
We can easily transfer our state file just changing configuration in `terraform.tf` file
and using:
```terraform
terraform init -migrate-state
```

### State refresh
We can refresh state if we observe any drift in configuration, use command:
```terraform
terraform apply -refresh-only
```






