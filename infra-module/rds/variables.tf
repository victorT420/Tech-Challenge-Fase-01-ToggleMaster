variable "name" {
  description = "Prefixo usado nos nomes dos recursos."
  type        = string
}

variable "vpc_id" {
  description = "ID da VPC onde o banco será criado."
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs de pelo menos duas sub-redes privadas em AZs distintas."
  type        = list(string)

  validation {
    condition     = length(var.private_subnet_ids) >= 2
    error_message = "O grupo de sub-redes do RDS precisa de pelo menos duas sub-redes."
  }
}

variable "ec2_security_group_id" {
  description = "ID do security group autorizado a acessar o banco."
  type        = string
}

variable "db_identifier" {
  description = "Identificador da instância RDS."
  type        = string
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