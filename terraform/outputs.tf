output "ec2_public_ip" {
  description = "Public IP of the EC2 instance"
  value       = aws_instance.todolist_ec2.public_ip
}

output "ec2_public_dns" {
  description = "Public DNS of the EC2 instance"
  value       = aws_instance.todolist_ec2.public_dns
}

output "ssh_command" {
  description = "Ready-to-use SSH command"
  value       = "ssh -i ${var.key_name}.pem ubuntu@${aws_instance.todolist_ec2.public_ip}"
}

output "private_key_file" {
  description = "Path to the generated .pem file"
  value       = local_file.private_key_pem.filename
}

output "app_url" {
  description = "URL to open in a browser (HTTP)"
  value       = "http://${aws_instance.todolist_ec2.public_ip}"
}