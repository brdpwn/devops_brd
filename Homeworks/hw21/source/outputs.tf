output "public_ips" {
  description = "Public IPs of the EC2 instances"
  value       = aws_instance.nginx[*].public_ip
}

output "ansible_hosts" {
  description = "Path to generated Ansible hosts file"
  value       = "${path.module}/ansible/hosts.txt"
}

