output "instance_id" {
  description = "ID da instância EC2."
  value       = aws_instance.this.id
}

output "public_ip" {
  description = "IP público da instância EC2."
  value       = aws_instance.this.public_ip
}

output "public_dns" {
  description = "DNS público da instância EC2."
  value       = aws_instance.this.public_dns
}

output "key_name" {
  description = "Nome do key pair SSH criado na AWS."
  value       = aws_key_pair.this.key_name
}

output "kms_key_id" {
  description = "ID da chave KMS que criptografa o parametro SecureString da chave privada."
  value       = aws_kms_key.ssh_private_key.key_id
}

output "kms_key_arn" {
  description = "ARN da chave KMS usada para criptografar o parametro SSM."
  value       = aws_kms_key.ssh_private_key.arn
}

output "private_key_parameter_name" {
  description = "Nome do parametro SSM SecureString usado para armazenar a chave privada."
  value       = "/${var.name}/ec2/ssh-private-key"
}