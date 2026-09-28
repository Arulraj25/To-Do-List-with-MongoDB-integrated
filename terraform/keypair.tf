# Generate a new RSA private key locally
resource "tls_private_key" "todolist_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Register the public key in AWS
# Official docs confirm: aws_key_pair requires existing user-supplied public key
# Reference: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair
resource "aws_key_pair" "todolist_kp" {
  key_name   = var.key_name
  public_key = tls_private_key.todolist_key.public_key_openssh
}

# Save the private key to disk as a .pem file
resource "local_file" "private_key_pem" {
  content         = tls_private_key.todolist_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}