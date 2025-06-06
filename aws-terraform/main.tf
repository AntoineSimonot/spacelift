// ────────────────────────────────────────────────────────────────────────────
//        main.tf
// ────────────────────────────────────────────────────────────────────────────

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

resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-minimal-2-webservers"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PRIVATE_SUBNET_CIDR
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-private-webservers"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main-internet-gateway"
  }
}

# Route par défaut vers l'Internet pour tester si besoin
resource "aws_route" "public_internet" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
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

resource "aws_security_group" "webservers_sg" {
  name        = "webservers-sg"
  description = "SG for webservers: HTTP and SSH"
  vpc_id      = aws_vpc.main.id

  # HTTP (80) entre webservers eux-mêmes (communication interne)
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    description = "Allow HTTP between webservers"
  }

  # SSH (22) ouvert pour tester, à restreindre ultérieurement
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH from outside (restrict later)"
  }

  # Tout trafic sortant autorisé
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "webservers-sg"
  }
}

###################################################
# 4. Instances EC2 (deux serveurs web dans le subnet)
###################################################

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
