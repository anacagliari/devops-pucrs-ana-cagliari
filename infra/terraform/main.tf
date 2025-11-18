terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Security Group para permitir HTTP e SSH
resource "aws_security_group" "web_sg" {
  name        = "projeto-devops-ana-cagliari"
  description = "Security group para aplicacao Angular"

  # Permite HTTP na porta 80
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite SSH na porta 22
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Permite todo tráfego de saída
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "projeto-devops-ana-cagliari"
  }
}

# Instância EC2
resource "aws_instance" "web_server" {
  ami           = var.ami_id
  instance_type = var.instance_type

  security_groups = [aws_security_group.web_sg.name]

  key_name = var.key_name

  user_data = <<-EOF
              #!/bin/bash
              # Atualiza o sistema
              yum update -y

              # Instala Docker
              yum install docker -y

              # Inicia Docker
              systemctl start docker
              systemctl enable docker

              # Adiciona ec2-user ao grupo docker
              usermod -aG docker ec2-user

              # Instala docker-compose
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              EOF

  tags = {
    Name    = "projeto-devops-ana-cagliari"
    Project = "DevOps-PUCRS"
    Owner   = "Ana Caroline Cagliari Cappellari"
  }
}
