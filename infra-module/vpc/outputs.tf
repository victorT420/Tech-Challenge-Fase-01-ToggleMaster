output "vpc_id" {
  description = "ID da VPC criada."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "IDs das sub-redes públicas."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs das sub-redes privadas."
  value       = aws_subnet.private[*].id
}