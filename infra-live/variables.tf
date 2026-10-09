variable "project_name" {
  description = "Prefixo dos recursos deste ambiente."
  type        = string
  default     = "fiap-app"
}

variable "ssh_allowed_cidr" {
  description = "IP público autorizado para SSH em CIDR, por exemplo 203.0.113.10/32."
  type        = string
}

variable "ec2_key_name" {
  description = "Nome do par de chaves SSH que o Terraform criara na região AWS selecionada."
  type        = string
}

variable "ssh_public_key_path" {
  description = "Caminho local da chave SSH publica correspondente a chave privada que sera armazenada no SSM com KMS."
  type        = string
  default     = "~/.ssh/fiap-app.pub"
}

variable "ec2_instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}

variable "db_identifier" {
  description = "Identificador da instância RDS."
  type        = string
  default     = "fiap-app-db"
}

variable "db_engine" {
  description = "Engine do banco: postgres ou mysql."
  type        = string
  default     = "postgres"

  validation {
    condition     = contains(["postgres", "mysql"], var.db_engine)
    error_message = "db_engine deve ser postgres ou mysql."
  }
}

variable "db_instance_class" {
  description = "Classe da instância RDS."
  type        = string
  default     = "db.t3.micro"
}

variable "allocated_storage" {
  description = "Armazenamento alocado em GiB."
  type        = number
  default     = 20
}

variable "db_name" {
  description = "Nome inicial do banco de dados."
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuário administrador do banco."
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Senha do usuário administrador do banco."
  type        = string
  sensitive   = true
}

variable "skip_final_snapshot" {
  description = "Ignora snapshot final ao destruir o banco. Mantenha false em produção."
  type        = bool
  default     = true
}

variable "deletion_protection" {
  description = "Ativa proteção contra exclusão da instância RDS."
  type        = bool
  default     = false
}