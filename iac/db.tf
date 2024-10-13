resource "aws_db_subnet_group" "myapp_db_subnet_group" {
  name       = "myapp-db-subnet-group"
  subnet_ids = [aws_subnet.myapp_subnet_a.id, aws_subnet.myapp_subnet_b.id] # Substitua pelos IDs das subnets criadas

  tags = {
    Name = "MyApp DB Subnet Group"
  }
}

resource "aws_db_instance" "myapp_db" {
  allocated_storage      = 10
  db_name                = "myapp"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "myapp_user"
  password               = "myapp_passwd"
  parameter_group_name   = "default.mysql8.0"
  availability_zone      = "us-east-1a"
  vpc_security_group_ids = [aws_security_group.posweb_mydb_2024_sg.id]
  skip_final_snapshot    = true

  db_subnet_group_name = aws_db_subnet_group.myapp_db_subnet_group.name # Associar ao Subnet Group

  tags = {
    Name = "MyApp RDS DB"
  }
}

resource "aws_security_group" "posweb_mydb_2024_sg" {
  name        = "posweb_mydb_2024"
  description = "Allow MYDB inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.myapp_vpc.id # Alterado para utilizar uma VPC específica

  tags = {
    Name = "posweb_mydb_2024_sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "posweb_mydb_2024_allow_mysql" {
  security_group_id = aws_security_group.posweb_mydb_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 3306
  ip_protocol       = "tcp"
  to_port           = 3306
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_mydb" {
  security_group_id = aws_security_group.posweb_mydb_2024_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
