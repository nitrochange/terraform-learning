# output "public_ip" {
#   description = "This is the public IP of my web server"
#   value = aws_instance.web_server.public_ip
# }

output "phone_number" {
  value = data.vault_generic_secret.phone_number
  sensitive = true
}