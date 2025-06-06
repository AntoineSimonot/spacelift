#####################
# Terraform & Providers
#####################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # Aucun bloc backend ici : Spacelift gère l’état (S3) à l’extérieur du code
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

###################################
# 1. Création du VPC + Sous-réseau
###################################

data "aws_availability_zones" "available" {}

# 1.1 VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-minimal-2-webservers"
  }
}

# 1.2 Sous-réseau privé (pour héberger les 2 EC2)
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-private-webservers"
  }
}

###########################################
# 2. Key Pair SSH (import du contenu textuel)
###########################################

resource "aws_key_pair" "deploy_key" {
  key_name   = "key-deployment"
  public_key = var.SSH_PUBLIC_KEY
}

#############################################
# 3. Security Group (pour les 2 serveurs Web)
#############################################

# Nom ne commençant pas par "sg-"
resource "aws_security_group" "webservers_sg" {
  name        = "webservers-sg"
  description = "HTTP entre webservers + SSH depuis Bastion Azure"
  vpc_id      = aws_vpc.main.id

  # HTTP (80) depuis le même SG (communication interne)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    description = "HTTP interne entre webservers"
  }

  # SSH (22) depuis Bastion Azure (CIDR Azure)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.AZURE_VPN_PREFIX]
    description = "SSH depuis Bastion Azure"
  }

  # Tout trafic sortant autorisé
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "webservers-sg"
  }
}

###################################################
# 4. Instances EC2 (deux serveurs web dans le subnet)
###################################################

# 4.1 EC2 #1
resource "aws_instance" "web1" {
  ami                         = "ami-0779caf41f9ba54f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.webservers_sg.id]
  key_name                    = aws_key_pair.deploy_key.key_name
  associate_public_ip_address = false

  tags = {
    Name = "ec2-webserver-1"
  }
}

# 4.2 EC2 #2
resource "aws_instance" "web2" {
  ami                         = "ami-0779caf41f9ba54f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.webservers_sg.id]
  key_name                    = aws_key_pair.deploy_key.key_name
  associate_public_ip_address = false

  tags = {
    Name = "ec2-webserver-2"
  }
}

###################
# 5. Outputs clés
###################

# VPC et Subnet
output "vpc_id" {
  description = "ID du VPC créé"
  value       = aws_vpc.main.id
}
output "private_subnet_id" {
  description = "ID du subnet privé hébergeant les webservers"
  value       = aws_subnet.private.id
}

# Security Group
output "webservers_sg_id" {
  description = "ID du Security Group des webservers"
  value       = aws_security_group.webservers_sg.id
}

# Instances EC2
output "web1_instance_id" {
  description = "ID de la première instance web"
  value       = aws_instance.web1.id
}
output "web1_private_ip" {
  description = "IP privée de la première instance web"
  value       = aws_instance.web1.private_ip
}

output "web2_instance_id" {
  description = "ID de la seconde instance web"
  value       = aws_instance.web2.id
}
output "web2_private_ip" {
  description = "IP privée de la seconde instance web"
  value       = aws_instance.web2.private_ip
}