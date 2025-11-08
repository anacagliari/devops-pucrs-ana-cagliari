# Output do IP publico
output "instance_public_ip" {
  description = "IP publico da instancia EC2"
  value       = aws_instance.web_server.public_ip
}

output "instance_id" {
  description = "ID da instancia EC2"
  value       = aws_instance.web_server.id
}
