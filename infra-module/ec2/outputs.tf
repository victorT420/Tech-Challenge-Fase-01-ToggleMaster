output "security_group_id" {
  description = "ID do security group da EC2."
  value       = aws_security_group.this.id
}