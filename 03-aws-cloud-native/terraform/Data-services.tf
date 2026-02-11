

## RDS Subnet Group

resource "aws_db_subnet_group" "RDS_subnet_group" {
  name       = "RDS_subnet_group"
  subnet_ids = [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "DB subnet group"
  }
}

### RDS Instance

resource "aws_db_instance" "RDS" {
  allocated_storage      = 20
  db_name                = var.db_name
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  parameter_group_name   = "default.mysql8.0"
  multi_az               = false
  publicly_accessible    = false
  skip_final_snapshot    = true
  username               = var.db_user_name
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.RDS_subnet_group.name
  vpc_security_group_ids = [aws_security_group.Data-SG.id]
}


#### ---------------------------------------------------------------------------------------------

## ElastiCache Subnet Group

resource "aws_elasticache_subnet_group" "ElastiCache_subnet_group" {
  name       = "ElastiCache_subnet_group"
  subnet_ids =  [module.vpc.private_subnets[0], module.vpc.private_subnets[1], module.vpc.private_subnets[2]]

  tags = {
    Name = "ElastiCache_subnet_group"
  }
}

### ElastiCache Cluster

resource "aws_elasticache_cluster" "ElastiCache" {
  cluster_id           = "ElastiCache"
  engine               = "memcached"
  node_type            = "cache.t3.micro"
  num_cache_nodes      = 1
  subnet_group_name    = aws_elasticache_subnet_group.ElastiCache_subnet_group.name
  security_group_ids   = [aws_security_group.Data-SG.id]
  parameter_group_name = "default.memcached1.4"
  port                 = 11211
}