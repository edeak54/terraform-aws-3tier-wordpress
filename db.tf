resource "aws_db_subnet_group" "wp_db_group" {
  name       = "wp-db-subnet-group"
  subnet_ids = [aws_subnet.db_1.id, aws_subnet.db_2.id]

  tags = {
    Name = "WP DB Subnet Group"
  }
}

# db instance
resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  db_name                = "wordpress"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.wp_db_group.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  skip_final_snapshot    = true
}
