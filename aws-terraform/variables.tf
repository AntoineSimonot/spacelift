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
  default     = "IQoJb3JpZ2luX2VjEG8aCXVzLXdlc3QtMiJHMEUCIQCj9OXYu6Mt6eUlxoLjGUVwY8+wrd2NMcdC7vLd3PP+eAIgTGpZgbidMSRJ0vloBOrItL16MraqJbqDHbow5LApOCAqqQIISBAAGgw0MDc4NjM5MzIwMDciDOrsnhlXUh5+DR7BrSqGAgnagoS0iy4533LMv2m1HQhcEB6SUPN5nC4h63prUhI0mDsqJr6L4sz7PXK/O/d4E3+ojBzM7Z3UvgrWE6k0J4mvw0jr/cn+6lXZTiUXUsV4s6D7kdhfQ/kurhvPhoo2zFGFpLCM76lwzW3fbQnTMpIx1dOYVjn3NYAx5Ndqh07enTImJfY/WLEbBS1R4xnmao7qnoDh1NihHzGhEUsjEMgHdhL7DiCGmDgj2LK7Uw26Uez2fMLW7j0F2ipV8waNRUgfuG76D13zWqxXOZYn97vHq/vKjyNAz18giDPp2tVvD3wRu9UHHPbouMmswQxJsfPK5ywxdH98OdyA28VRueSkfdcgzFownOeGwgY6nQEhSte9ilT8Dryv5rO9zveDbqdZ+q5rQnlGT48YGF77rx8+cAvqFEQ/k27bY4wrb3S7oEQDI196wMlKNlRzpvtlO20ZVcO0sSzkm3WhfTeyJ14mDqhw8TseQiSI2ztfk9//e5XgQ8tTfAjFS+kLBr72it3LHNUJ+Wb9PewHJyATFDEmRDqE+sqxTNchREGOcPUUmcBVw95nBwQZUFQU"
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