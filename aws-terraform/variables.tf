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

# 3. Clé publique SSH (contenu textuel, non chemin de fichier)
variable "SSH_PUBLIC_KEY" {
  description = "Contenu de la clé publique SSH (ex. contenu de ~/.ssh/id_deployment.pub)"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHOwRj/RMQIXAVjZptf8bboC5ZcCj7TmWNyrpT4egcCeC2TD30qZJFao57LAYI6wTIQJiFWRMp1PAqVQY/2jUzw29Nn8uUgTVg63NTH8nKgK2UvifyrNb1bwwP/77VAisps8b/fUjsdl1Vd77Q0Zxyi2bUm5dEcMBuWqnZxXTq00qyAXsx1Bfei/8Y+X2knfrRdbuhJdVzFqz/sAUhjGAIN/IRVHDVoMz4PgQZgGuxXdKbzgHN2xz5bm3oM0epsw3D7aV8Fyf8IVtKCbpd2QphGSLNhLOjJza8tm4afxJw/r1fK6w3xCGdWapcWoTxSL4RPfn/Xar0faEH7mZPUwgYs3RySldTdsoU13M/wCuSrrusMtlhAj0xO+AuGN63cXzXYr7RN/O8or0wSea/usXsMU7ndXrHaUiDR/0hVvl4RBS6mj3HZTok4SjHFOH9OXB10zrbnPPKiS/phdPmMVslZyDUciETVadLV1gsJAEccAzSHbCVjDIl5W0HJKIvFtJiHh2zP/rCN4qvsxw/5JsJ4xUR8LBCBurBaMtt5UWoqPXu1B+TfIoc1YIwije0wf5VUF+H6AfWazTK4lFLweoySkWtk/FvaFaGEaHgbOqSl/PTaRUMDxIHsFaqESDOImeg5CFm8TTNrq+KQSKlqhbE3LFYtCkU74qAzG7Q4PUCEQ== antoine@DESKTOP-32GVOH3"
  sensitive   = true
}

# (On laisse de côté toute variable Azure/Azure VPN pour l'instant)
