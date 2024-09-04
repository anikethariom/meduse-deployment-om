# rds.tf 

resource "aws_db_instance" "medusa_db" {
  allocated_storage    = "20"
  engine               = "postgres"
  engine_version       = "13"
  instance_class       = "db.t4g.micro"
  name                 = "medusadb"
  username             = "medusa_user"
  password             = "supersecurepassword"
  parameter_group_name = "default.postgres13"
  punlicly_accessible  = true
  skip_final_snapshot  = true

  vpc_security_group_ids = [aws_security_group.medusa_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.medusa_subnet_group.name 
 }

resource "aws_db_subnet_group" "medusa_subnet_group" {
   name       = "medusa-db-subnet-group"
   subnet_ids = [aws_subnet.medusa_subnet.id]
 
   tags = {
     name = "medusa-db-subnet-group"
    }
  }

