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
  default     = "ASIAV55UWRTZ3DAN3YN"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  default     = "bDBMXRsf3/w6pkm/VEVNkFbggbfeU1ruzeghlDtk"
  sensitive   = true
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS Session Token"
  default     = "IQoJb3JpZ2luX2VjEGQaCXVzLXdlc3QtOWE2bGE6CjQ9YjMHEUIQCJ9XYuM6t6eUlxoLJgWV8+wrzdMNcdCrYvLd3PP+eAl9TGpZGbjdmSRj0vRDbTL1t6MHarg3bQDVDhow5LApOCAggQIISBACwgM?d4vfaN5JMzbWImMdCiOrshnIUXhS+Db7RbSqGANzg0jIy4533L2Ym2hnCHcHEB5UPSns4cHi3rpUh1D0s3LnJqgGIFL5Az7PXk/O/d4E+8o3jbMzW3suszk4Dm+PNW/7cn+61XZTtIUoVs4Vs6D7Kkdn/FQ/kurhvPnoo2zFFpLG/F16LWZ3FbfQmTmp1xd1oYnZusNYvAShNoQN0ft7emTlfYrWLLGbSrlAxmmoa7qnDoHNtNbGhHEUjsEgMhdh7LCiCm_gJ2LK7uw26Uez2fMLw7jFr2iP8y8waNRgFu678D13I3wkxJOYb9ZvHq/vkJvNwAzl78igDlnP2rvD3Bw9UHNpHPouHmswoXJsFPLXVwch98QdvA2ERV8eSkfcdzrFovwaCgFW6Gn8hpTkjpFZ0vry5vnZ6RNbDrdqdZ+5rQnGLT84YGF7rrX8+cAQvFEQ/k27By4wrb35?oE0Dl196WlKN1Rzpvrl020ZvCO8Szkm3WhfTeyJ14mDphw8Ts0EiSzI2tfk9/EySXq8tfAtFjaYfS+kLBrz1tL3HNUJ+wB9PWehyJlATDFEmRdQa+sqxTChNREC0cPUUnbcWv95nBwQZUFQ=="
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

# 3. Chemin vers la clé publique SSH (pour AWS Key Pair)
variable "SSH_PUBLIC_KEY_PATH" {
  description = "Chemin local vers la clé publique SSH"
  default     = "~/.ssh/id_deployment.pub"
}

# 4. CIDR du Bastion Azure (pour autoriser SSH depuis Bastion vers AWS)
variable "AZURE_VPN_PREFIX" {
  description = "CIDR de la VNet Azure (ex. 10.1.0.0/16)"
  default     = "10.1.0.0/16"
}