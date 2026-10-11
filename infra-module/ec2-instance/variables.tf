variable "name" {
  description = "Prefixo usado no nome da instância."
  type        = string
}

variable "public_subnet_id" {
  description = "ID da sub-rede pública onde a instância será criada."
  type        = string
}

variable "security_group_id" {
  description = "ID do security group associado à instância."
  type        = string
}

variable "key_name" {
  description = "Nome do par de chaves SSH a criar na região AWS."
  type        = string
}

variable "public_key_path" {
  description = "Caminho local da chave SSH publica."
  type        = string
}

variable "instance_type" {
  description = "Tipo da instância EC2."
  type        = string
  default     = "t3.micro"
}