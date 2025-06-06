#################################
# Variables AWS (remplies d’après vos infos)
#################################

# --- Authentification AWS (injectées directement par défaut) ---
variable "AWS_REGION" {
  description = "Région AWS"
  default     = "us-east-1"
}

variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
  default     = "ASIAV55UWRTZ3DAN3YN"       # votre access key
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
  default     = "bDBMXRsf3/w6pkm/VEVNkFbggbfeU1ruzeghlDtk"   # votre secret key
  sensitive   = true
}

variable "AWS_SESSION_TOKEN" {
  description = "AWS Session Token"
  default     = "IQoJb3JpZ2luX2VjEGQaCXVzLXdlc3QtOWE2bGE6CjQ9YjMHEU\
IQCJ9XYuM6t6eUlxoLJgWV8+wrzdMNcdCrYvLd3PP+eAl9TGpZGbjdmSRj0vRDbTL\
1t6MHarg3bQDVDhow5LApOCAggQIISBACwgM?d4vfaN5JMzbWImMdCiOrshnIUXhS+\
Db7RbSqGANzg0jIy4533L2Ym2hnCHcHEB5UPSns4cHi3rpUh1D0s3LnJqgGIFL5Az7\
PXk/O/d4E+8o3jbMzW3suszk4Dm+PNW/7cn+61XZTtIUoVs4Vs6D7Kkdn/FQ/kurhvP\
noo2zFFpLG/F16LWZ3FbfQmTmp1xd1oYnZusNYvAShNoQN0ft7emTlfYrWLLGbSrlAx\
mmoa7qnDoHNtNbGhHEUjsEgMhdh7LCiCm_gJ2LK7uw26Uez2fMLw7jFr2iP8y8waNR\
gFu678D13I3wkxJOYb9ZvHq/vkJvNwAzl78igDlnP2rvD3Bw9UHNpHPouHmswoXJsFP\
LXVwch98QdvA2ERV8eSkfcdzrFovwaCgFW6Gn8hpTkjpFZ0vry5vnZ6RNbDrdqdZ+5\
rQnGLT84YGF7rrX8+cAQvFEQ/k27By4wrb35?oE0Dl196WlKN1Rzpvrl020ZvCO8Sz\
km3WhfTeyJ14mDphw8Ts0EiSzI2tfk9/EySXq8tfAtFjaYfS+kLBrz1tL3HNUJ+wB9P\
WehyJlATDFEmRdQa+sqxTChNREC0cPUUnbcWv95nBwQZUFQ=="   # votre session token (sensible)
  sensitive   = true
}

# --- CIDR du réseau (injection Spacelift) ---
variable "VPC_CIDR" {
  description = "CIDR du VPC principal"
  default     = "10.0.0.0/16"
}

variable "PUBLIC_SUBNET_CIDR" {
  description = "CIDR du sous-réseau public (Web)"
  default     = "10.0.1.0/24"
}

variable "PRIVATE_SUBNET_APP_CIDR" {
  description = "CIDR du sous-réseau privé (App)"
  default     = "10.0.2.0/24"
}

# --- Chemin vers la clé publique SSH (injection Spacelift) ---
variable "SSH_PUBLIC_KEY_PATH" {
  description = "Chemin local vers la clé publique SSH"
  default     = "~/.ssh/id_deployment.pub"
}

# --- CIDR du Bastion Azure (injection Spacelift) ---
variable "AZURE_VPN_PREFIX" {
  description = "CIDR de la VNet Azure (pour autoriser SSH Bastion→AWS)"
  default     = "10.1.0.0/16"
}