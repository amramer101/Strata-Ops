##### -------------------  MySQL Database in SSM ------------------- #####
## Mysql Endpoint
resource "aws_ssm_parameter" "rds_endpoint" {
  name  = "/strata/rds_endpoint"
  type  = "String"
  value = aws_db_instance.RDS.address
}

### MySQL Password
resource "random_password" "db_password" {
  length  = 8
  special = false
}
resource "aws_ssm_parameter" "rds_password" {
  name  = "/strata/rds_password"
  type  = "SecureString"
  value = random_password.db_password.result
}

### MySQL Username
resource "aws_ssm_parameter" "rds_username" {
  name  = "/strata/rds_username"
  type  = "String"
  value = var.db_user_name
}

###### -------------------  RabbitMQ in SSM ------------------- #####

# RabbitMQ Endpoint
resource "aws_ssm_parameter" "rabbitmq_endpoint" {
  name  = "/strata/rabbitmq_endpoint"
  type  = "String"
  value = aws_mq_broker.RabbitMQ.instances[0].endpoints[0]
}

#### RabbitMQ Password
resource "random_password" "rmq_password" {
  length  = 12
  special = false
}

resource "aws_ssm_parameter" "rabbitmq_password" {
  name  = "/strata/rabbitmq_password"
  type  = "SecureString"
  value = random_password.rmq_password.result
}

#### RabbitMQ Username
resource "aws_ssm_parameter" "rabbitmq_username" {
  name  = "/strata/rabbitmq_username"
  type  = "String"
  value = var.rmq_user
}

#### ---------------------- Memcached in SSM ---------------------- ##### 
# Memcached Endpoint
resource "aws_ssm_parameter" "memcached_endpoint" {
  name  = "/strata/memcached_endpoint"
  type  = "String"
  value = aws_elasticache_cluster.ElastiCache.cache_nodes[0].address
}

#### -------------------  ECR Repository in SSM ------------------- #####

resource "aws_ssm_parameter" "ecr_repository_name" {
  name  = "/strata/ecr_repository_name"
  type  = "String"
  value = aws_ecr_repository.Docker_tomcat.name
}

resource "aws_ssm_parameter" "ecr_registry" {
  name  = "/strata/ecr_registry"
  type  = "String"
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com"
}