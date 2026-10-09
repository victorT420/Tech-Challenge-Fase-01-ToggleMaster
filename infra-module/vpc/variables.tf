variable "name" {
  description = "Prefixo usado nos nomes dos recursos."
  type        = string
}

variable "vpc_cidr" {
  description = "Bloco CIDR da VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs das duas sub-redes públicas, em AZs distintas."
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]

  validation {
    condition     = length(var.public_subnet_cidrs) == 2
    error_message = "Informe exatamente dois CIDRs para as sub-redes públicas."
  }
}

variable "private_subnet_cidrs" {
  description = "CIDRs das duas sub-redes privadas, em AZs distintas."
  type        = list(string)
  default     = ["10.0.11.0/24", "10.0.12.0/24"]

  validation {
    condition     = length(var.private_subnet_cidrs) == 2
    error_message = "Informe exatamente dois CIDRs para as sub-redes privadas."
  }
}