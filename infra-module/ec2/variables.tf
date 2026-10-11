variable "name" {
  description = "Prefixo usado nos nomes dos recursos."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o security group será criado."
  type        = string
}

variable "ssh_allowed_cidr" {
  description = "IP público autorizado para SSH em formato CIDR, por exemplo 203.0.113.10/32."
  type        = string

  validation {
    condition     = can(cidrhost(var.ssh_allowed_cidr, 0))
    error_message = "Informe um CIDR válido para liberar SSH."
  }
}