provider "aws" {
  region = "us-west-2"
  default_tags {
    tags = {
      Environment = terraform.workspace
      Owner       = "The best company in the world"
      Project     = "Infrastructure as Code"
      Terraform   = "true"
    }
  }
}

resource "random_pet" "server" {
  length = 2
}

# resource "aws_instance" "web_server_2" {
#   ami           = data.aws_ami.ubuntu.id
#   instance_type = "t3.micro"
#   subnet_id     = aws_subnet.public_subnets["public_subnet_2"].id
#   tags = {
#     Name = "Web EC2 Server 2"
#   }
# }
