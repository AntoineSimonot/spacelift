variable "azure_location" {
  description = "Emplacement géographique Azure (ex: East US)"
  default     = "East US"
}

variable "resource_group_name" {
  description = "Nom du Resource Group Azure"
  default     = "demo-rg"
}

variable "aws_region" {
  description = "Région AWS pour l'injection SSM"
  default     = "us-east-1"
}
