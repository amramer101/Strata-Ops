resource "random_password" "db_password" {
  length  = 8
  special = false
}

resource "aws_ssm_parameter" "mysql_password" {
  name  = "/strata-ops/mysql-password"
  type  = "SecureString"
  value = random_password.db_password.result
}


resource "random_password" "rmq_password" {
  length  = 12
  special = false
}

resource "aws_ssm_parameter" "rabbitmq_password" {
  name  = "/strata-ops/rabbitmq-password"
  type  = "SecureString"
  value = random_password.rmq_password.result
}

resource "aws_ssm_parameter" "ecr_repository_name" {
  name  = "/strata-ops/pipeline/ecr-repo"
  type  = "String"
  value = aws_ecr_repository.Docker_tomcat.name
}

resource "aws_ssm_parameter" "ecr_registry" {
  name  = "/strata-ops/pipeline/ecr-registry"
  type  = "String"
  value = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${data.aws_region.current.id}.amazonaws.com"
}


