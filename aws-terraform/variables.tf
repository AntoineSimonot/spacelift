// ────────────────────────────────────────────────────────────────────────────
//        variables.tf
// ────────────────────────────────────────────────────────────────────────────

############################################
# Variables AWS pour l’architecture minimale
############################################

# 1. Authentification AWS (valeurs par défaut pour tests)
variable "AWS_REGION" {
  description = "Région AWS"
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  default     = "ASIAV55UVWRTR5GQVZMT"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  default     = "gEOHXMj4av3CRcx4RI3NSQl1rORqP7EOsNOzkrGC"
  sensitive   = true
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS Session Token"
  default     = "IQoJb3JpZ2luX2VjEID//////////wEaCXVzLXdlc3QtMiJGMEQCIHO4pTDx0C0fsSMFJ3/SI5sXcLw01Y0ATzbgCcO9d4HLAiB+osgQggk3LQOQqBqE33H9vGP+m4k01n5bNIbbTg7Q0yqpAghZEAAaDDQwNzg2MzkzMjAwNyIM5Sy7sGNFkdYWutQIKoYCE0uDAFYGO5RXWlzcHTz7IheR2m6MU1peYv4PmKm7bpNyBiTWYH0kgTW8ZKb+tNiCu7TXPMeg3REM5USn/ymiGi10GIqqbsSC4PkntxECxnD6Hxx2HFb2dyrw0xFcco16uuks5F3wC3AFgeGDJvQ13OGGe55wpLHFaskS4i7rCzqr5GOF+9XWpE1QVXFvTPRhJvksVw7g8FrYRPPTeE9UcdCZKE83HyEr2yV9yYJNlBxVgeYHd9v2yTYO1Fb+DuM72tpHhUxSB20wd8NFMylzV1KQxeTunoCWpfpvMSCls0ebHgmLQaF5iEdlcMSgzoMI86J4vYEaT0oohMpoqAESkOKaPbgjtzCxv4rCBjqeAT8ahfLl6/mn67DWZk35wNVSmgJ0iCibgF9kQXrBRuBOgOj42dDBNxL4tdGB6/TOvEeJuwD5zmIJEX27ymP+B2n0dN3OMM3AhZAuOxZg9K4xjDb6XN0hpmY9ugcraV2Nj2jBVyyhnfmckS/12EvEmXhTtBTtpg9IWqW4WXJ9CljVeac9FT/0zNxsMWBRcP+sdvtMrsNjA9kDihqDsayG"
  sensitive   = true
}

# 2. CIDR du réseau (un seul subnet privé)
variable "VPC_CIDR" {
  description = "CIDR du VPC principal"
  default     = "10.0.0.0/16"
}

variable "PRIVATE_SUBNET_CIDR" {
  description = "CIDR du sous-réseau privé (où seront les deux EC2)"
  default     = "10.0.1.0/24"
}

# 3. Clé publique SSH (contenu textuel, non chemin de fichier)
variable "SSH_PUBLIC_KEY" {
  description = "Contenu de la clé publique SSH (ex. contenu de ~/.ssh/id_deployment.pub)"
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDHOwRj/RMQIXAVjZptf8bboC5ZcCj7TmWNyrpT4egcCeC2TD30qZJFao57LAYI6wTIQJiFWRMp1PAqVQY/2jUzw29Nn8uUgTVg63NTH8nKgK2UvifyrNb1bwwP/77VAisps8b/fUjsdl1Vd77Q0Zxyi2bUm5dEcMBuWqnZxXTq00qyAXsx1Bfei/8Y+X2knfrRdbuhJdVzFqz/sAUhjGAIN/IRVHDVoMz4PgQZgGuxXdKbzgHN2xz5bm3oM0epsw3D7aV8Fyf8IVtKCbpd2QphGSLNhLOjJza8tm4afxJw/r1fK6w3xCGdWapcWoTxSL4RPfn/Xar0faEH7mZPUwgYs3RySldTdsoU13M/wCuSrrusMtlhAj0xO+AuGN63cXzXYr7RN/O8or0wSea/usXsMU7ndXrHaUiDR/0hVvl4RBS6mj3HZTok4SjHFOH9OXB10zrbnPPKiS/phdPmMVslZyDUciETVadLV1gsJAEccAzSHbCVjDIl5W0HJKIvFtJiHh2zP/rCN4qvsxw/5JsJ4xUR8LBCBurBaMtt5UWoqPXu1B+TfIoc1YIwije0wf5VUF+H6AfWazTK4lFLweoySkWtk/FvaFaGEaHgbOqSl/PTaRUMDxIHsFaqESDOImeg5CFm8TTNrq+KQSKlqhbE3LFYtCkU74qAzG7Q4PUCEQ== antoine@DESKTOP-32GVOH3"
  sensitive   = true
}

# 4. CIDR du Bastion Azure (pour autoriser SSH Bastion→AWS)
variable "AZURE_VPN_PREFIX" {
  description = "CIDR de la VNet Azure (ex. 10.1.0.0/16)"
  default     = "10.1.0.0/16"
}
