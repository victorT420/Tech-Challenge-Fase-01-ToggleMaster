output "endpoint" {
  description = "Endpoint de conexão ao banco."
  value       = aws_db_instance.this.endpoint
}

output "address" {
  description = "Hostname da instância RDS."
  value       = aws_db_instance.this.address
}

output "port" {
  description = "Porta da instância RDS."
  value       = aws_db_instance.this.port
}

output "security_group_id" {
  description = "ID do security group do RDS."
  value       = aws_security_group.this.id
}