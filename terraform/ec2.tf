# Look up the latest official Ubuntu 22.04 LTS AMI
# Official example uses owners = ["099720109477"] (Canonical) [citation:5]
data "aws_ami" "ubuntu_2204" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

resource "aws_instance" "todolist_ec2" {
  ami                    = data.aws_ami.ubuntu_2204.id
  instance_type          = var.instance_type
  key_name               = aws_key_pair.todolist_kp.key_name
  vpc_security_group_ids = [aws_security_group.todolist_sg.id]

  # Bootstrap Docker via user_data (official approach for EC2 automation) [citation:30][citation:37]
  user_data = <<-EOF
    #!/bin/bash
    set -euxo pipefail

    apt-get update -y
    DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

    # Install Docker
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    usermod -aG docker ubuntu

    # Install Docker Compose v2 plugin
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -SL "https://github.com/docker/compose/releases/latest/download/docker-compose-linux-x86_64" \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    systemctl enable docker
    systemctl start docker

    mkdir -p /home/ubuntu/app
    chown -R ubuntu:ubuntu /home/ubuntu/app

    echo "user_data finished at $(date)" > /home/ubuntu/user-data-done.log
  EOF

  # Root block device — arguments verified from official instance resource docs [citation:7]
  root_block_device {
    volume_size = 20
    volume_type = "gp3"
    encrypted   = true
  }

  # Replace instance when SG changes (official recommendation to avoid SG deletion issues)
  # Reference: registry.terraform.io aws_security_group docs [citation:3]
  lifecycle {
    replace_triggered_by = [aws_security_group.todolist_sg]
  }
}