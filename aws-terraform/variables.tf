variable "AWS_REGION" {
  type        = string
  description = "Région AWS (ex: eu-west-3)"
}

variable "AWS_ACCESS_KEY_ID" {
  type        = string
  description = "Clé d'accès AWS"
}

variable "AWS_SECRET_ACCESS_KEY" {
  type        = string
  description = "Clé secrète AWS"
}

variable "AWS_SESSION_TOKEN" {
  type        = string
  description = "Token AWS temporaire (si applicable)"
  default     = null
}

variable "VPC_CIDR" {
  type        = string
  description = "CIDR du VPC AWS (ex: 10.0.0.0/16)"
}

variable "PRIVATE_SUBNET_CIDR" {
  type        = string
  description = "CIDR du sous-réseau privé (ex: 10.0.1.0/24)"
}

variable "SSH_PUBLIC_KEY" {
  type        = string
  description = "Clé publique SSH utilisée pour se connecter aux EC2"
}

# (On laisse de côté toute variable Azure/Azure VPN pour l'instant)
