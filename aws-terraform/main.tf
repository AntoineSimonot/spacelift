#####################
# Terraform & Backend
#####################

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  # Le backend S3 est activé et configuré directement dans Spacelift :
  #   Bucket, Key, Région : vous définissez via l’interface Spacelift.
  backend "s3" {}
}

provider "aws" {
  region     = var.AWS_REGION
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
  token      = var.AWS_SESSION_TOKEN
}

####################################
# 1. Création du VPC + Sous-réseaux
####################################

# Récupère la première AZ disponible
data "aws_availability_zones" "available" {}

# 1.1 VPC principal
resource "aws_vpc" "main" {
  cidr_block           = var.VPC_CIDR
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "vpc-2tiers"
  }
}

# 1.2 Sous-réseau public (pour Web)
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.PUBLIC_SUBNET_CIDR
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-public-web"
  }
}

# 1.3 Sous-réseau privé (pour App)
resource "aws_subnet" "private_app" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.PRIVATE_SUBNET_APP_CIDR
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "subnet-private-app"
  }
}

# 1.4 Internet Gateway (attaché au VPC)
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "igw-2tiers"
  }
}

# 1.5 Route Table publique (0.0.0.0/0 → IGW)
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "rt-public-2tiers"
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# 1.6 Route Table privée (pour le subnet App) — aucune route Internet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "rt-prive-2tiers"
  }
}

resource "aws_route_table_association" "private_app_assoc" {
  subnet_id      = aws_subnet.private_app.id
  route_table_id = aws_route_table.private_rt.id
}

###############################################
# 2. Key Pair SSH pour accéder aux EC2 (Web & App)
###############################################

resource "aws_key_pair" "deploy_key" {
  key_name   = "key-deployment"
  public_key = file(var.SSH_PUBLIC_KEY_PATH)
}

############################################
# 3. Security Groups (Web et App)
############################################

# 3.1 SG commun pour autoriser SSH depuis la VNet Azure (cidr = var.AZURE_VPN_PREFIX)
resource "aws_security_group" "sg_bastion_aws" {
  name        = "sg-bastion-aws"
  description = "Autorise SSH depuis le CIDR Azure vers AWS"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.AZURE_VPN_PREFIX]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-bastion-aws"
  }
}

# 3.2 SG pour la couche Web (public)
resource "aws_security_group" "sg_web" {
  name        = "sg-web"
  description = "Autorise HTTP (80) depuis Internet et SSH (22) depuis Bastion Azure"
  vpc_id      = aws_vpc.main.id

  # HTTP depuis 0.0.0.0/0
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # SSH depuis Bastion Azure (via sg_bastion_aws)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion_aws.id]
  }

  # Tout le trafic sortant autorisé
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-web"
  }
}

# 3.3 SG pour la couche App (privée)
resource "aws_security_group" "sg_app" {
  name        = "sg-app"
  description = "Autorise le port 8080 depuis la couche Web et SSH (22) depuis Bastion Azure"
  vpc_id      = aws_vpc.main.id

  # Port 8080 depuis sg-web uniquement
  ingress {
    from_port       = 8080
    to_port         = 8080
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_web.id]
  }
  # SSH depuis Bastion Azure (via sg_bastion_aws)
  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.sg_bastion_aws.id]
  }

  # Tout le trafic sortant autorisé
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg-app"
  }
}

##############################################
# 4. Instances EC2 (Web/public, App/privé)
##############################################

# 4.1 Instance Web (front-end) – subnet public
resource "aws_instance" "web" {
  ami                         = "ami-0779caf41f9ba54f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.sg_web.id]
  key_name                    = aws_key_pair.deploy_key.key_name
  associate_public_ip_address = true

  tags = {
    Name = "ec2-web-frontend"
  }
}

# 4.2 Instance App (back-end) – subnet privé (sans IP publique)
resource "aws_instance" "app" {
  ami                         = "ami-0779caf41f9ba54f0"
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.private_app.id
  vpc_security_group_ids      = [aws_security_group.sg_app.id]
  key_name                    = aws_key_pair.deploy_key.key_name
  associate_public_ip_address = false

  tags = {
    Name = "ec2-app-backend"
  }
}

###################
# 5. Outputs clés
###################

# VPC et subnets
output "vpc_id" {
  description = "ID du VPC principal"
  value       = aws_vpc.main.id
}
output "public_subnet_id" {
  description = "ID du sous-réseau public (Web)"
  value       = aws_subnet.public.id
}
output "private_app_subnet_id" {
  description = "ID du sous-réseau privé (App)"
  value       = aws_subnet.private_app.id
}

# Security Groups
output "sg_bastion_aws_id" {
  description = "ID du SG autorisant SSH Bastion → AWS"
  value       = aws_security_group.sg_bastion_aws.id
}
output "sg_web_id" {
  description = "ID du Security Group pour Web"
  value       = aws_security_group.sg_web.id
}
output "sg_app_id" {
  description = "ID du Security Group pour App"
  value       = aws_security_group.sg_app.id
}

# Instances EC2 Web & App
output "web_instance_id" {
  description = "ID de l’instance EC2 Web"
  value       = aws_instance.web.id
}
output "web_public_ip" {
  description = "IP publique de l’instance Web"
  value       = aws_instance.web.public_ip
}
output "web_private_ip" {
  description = "IP privée de l’instance Web"
  value       = aws_instance.web.private_ip
}

output "app_instance_id" {
  description = "ID de l’instance EC2 App"
  value       = aws_instance.app.id
}
output "app_private_ip" {
  description = "IP privée de l’instance App"
  value       = aws_instance.app.private_ip
}