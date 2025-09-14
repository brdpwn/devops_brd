output "instance_public_ip" {
  description = "Public IP of the created instance"
  value       = module.ec2_nginx.public_ip
}

output "http_url" {
  value       = "http://${module.ec2_nginx.public_ip}"
  description = "Open this in your browser to check Nginx"
}

