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
  description = "HTTP entre webservers + SSH depuis Bastion Azure"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    self        = true
    description = "HTTP interne entre webservers"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.AZURE_VPN_PREFIX]
    description = "SSH depuis Bastion Azure"
  }

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

########################################
# 5. VPN Site-to-Site AWS vers Azure
########################################

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = 65000
  ip_address = var.azure_vpn_public_ip
  type       = "ipsec.1"
  tags = {
    Name = "CustomerGatewayToAzure"
  }
}

resource "aws_vpn_gateway" "vgw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "VPNGateway"
  }
}

resource "aws_vpn_connection" "vpn" {
  customer_gateway_id = aws_customer_gateway.cgw.id
  type                = "ipsec.1"
  vpn_gateway_id      = aws_vpn_gateway.vgw.id
  static_routes_only  = true
  tags = {
    Name = "AWS-Azure-VPN"
  }
}

resource "aws_vpn_connection_route" "to_azure" {
  vpn_connection_id       = aws_vpn_connection.vpn.id
  destination_cidr_block  = var.azure_subnet_cidr
}

resource "aws_route" "to_azure_vpn" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = var.azure_subnet_cidr
  vpn_gateway_id         = aws_vpn_gateway.vgw.id
}

resource "aws_eip" "vpn" {
  instance = null
  vpc      = true
  tags = {
    Name = "VPN EIP (if needed)"
  }
}