resource "aws_db_subnet_group" "db_sub" {
  name       = "db-subnet-group"
  subnet_ids = [aws_subnet.private-subnet-3.id, aws_subnet.private-subnet-4.id]
}

resource "aws_db_instance" "default" {
  allocated_storage      = 10
  db_name                = "db3tierproject"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = var.user_name
  password               = var.user_pass
  db_subnet_group_name   = aws_db_subnet_group.db_sub.name
  vpc_security_group_ids = [aws_security_group.vpc-db-tier-sg.id]
  skip_final_snapshot    = true
  multi_az               = true
}