output "public_ip" {
  value       = aws_instance.web.public_ip
  description = "Public IPv4 of the Nginx instance"
}

