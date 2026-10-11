resource "aws_security_group" "this" {
  name        = "${var.name}-rds"
  description = "Permite acesso ao banco somente pelo security group da EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Acesso ao banco vindo do security group da EC2"
    from_port       = local.database_port
    to_port         = local.database_port
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name}-rds-sg"
  }
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-rds"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.name}-rds-subnets"
  }
}

resource "aws_db_instance" "this" {
  identifier                 = var.db_identifier
  engine                     = var.db_engine
  instance_class             = var.db_instance_class
  allocated_storage          = var.allocated_storage
  db_name                    = var.db_name
  username                   = var.db_username
  password                   = var.db_password
  port                       = local.database_port
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = [aws_security_group.this.id]
  publicly_accessible        = false
  storage_encrypted          = true
  backup_retention_period    = 7
  auto_minor_version_upgrade = true
  skip_final_snapshot        = var.skip_final_snapshot
  deletion_protection        = var.deletion_protection
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.db_identifier}-final"

  tags = {
    Name = var.db_identifier
  }
}

locals {
  database_port = var.db_engine == "postgres" ? 5432 : 3306
}