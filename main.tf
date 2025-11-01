provider "aws" {
  region = "ap-south-1"
}

# 1. Create Security Group for MySQL
resource "aws_security_group" "rds_sg" {
  name        = "Mona-rds-sg"
  description = "Security group for RDS MySQL"
  vpc_id      = ""vpc-062a64eb167bf466e

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Consider restricting this for security
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "MonaRDS-SG"
  }
}

# 2. Create DB Subnet Group
resource "aws_db_subnet_group" "mona_db_subnet_group" {
  name        = "Mona-db-subnet-group"
  description = "Subnet group for RDS MySQL"
  subnet_ids  = [
    "subnet-020fe5b35678a7f43",
    "subnet-00c8ecff39630e95e"
  ]

  tags = {
    Name = "MonaDBSubnetGroup"
  }
}

# 3. Create RDS Instance
resource "aws_db_instance" "Mona_rds" {
  identifier              = "Mona-mysql-db"
  allocated_storage       = 20
  engine                  = "mysql"
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  db_name                 = "Mona_DB"
  username                = "admin"
  password                = "Monalisa"
  parameter_group_name    = "default.mysql8.0"
  skip_final_snapshot     = true

  db_subnet_group_name    = aws_db_subnet_group.shagun_db_subnet_group.name
  vpc_security_group_ids  = [aws_security_group.rds_sg.id]

  publicly_accessible     = true
  multi_az                = false
  backup_retention_period = 7
  storage_type            = "gp2"

  tags = {
    Name        = "MonaRDS"
    Environment = "Dev"
  }
}


 
