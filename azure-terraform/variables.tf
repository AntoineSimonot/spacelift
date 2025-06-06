variable "azure_location" {
  description = "Emplacement géographique Azure (ex: East US)"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Nom du Resource Group Azure"
  default     = "demo-rg"
}

variable "aws_region" {
  description = "Région AWS pour l'injection de la clé SSH dans SSM"
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID (pour aws_ssm_parameter)"
  type        = string
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key (pour aws_ssm_parameter)"
  type        = string
  sensitive   = true
}
