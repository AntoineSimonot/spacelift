variable "AWS_REGION" {
  description = "Région AWS (ex : eu-west-3)"
  type        = string
}

variable "AWS_ACCESS_KEY_ID" {
  description = "Clé d'accès AWS"
  type        = string
  sensitive   = true
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "Clé secrète AWS"
  type        = string
  sensitive   = true
}

variable "VPC_CIDR" {
  description = "CIDR du VPC AWS (ex : 10.0.0.0/16)"
  type        = string
}

variable "PRIVATE_SUBNET_CIDR" {
  description = "CIDR du sous-réseau privé (ex : 10.0.1.0/24)"
  type        = string
}

variable "SSH_PUBLIC_KEY" {
  description = "Clé publique SSH pour les EC2"
  type        = string
}

# -----------------------------------
# Variables pour la partie VPN AWS
# -----------------------------------
variable "azure_public_ip" {
  description = "IP publique de la VPN Gateway Azure (Local Network Gateway)"
  type        = string
}

variable "azure_cidr" {
  description = "CIDR du réseau Azure à joindre (ex : 10.1.0.0/16)"
  type        = string
}

variable "psk_override" {
  description = "Optionnel : forcer un PSK statique (laisse vide pour en générer un automatiquement)"
  type        = string
  default     = ""
}
