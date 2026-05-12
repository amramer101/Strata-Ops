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

resource "aws_ssm_parameter" "ecs_cluster_name" {
  name  = "/strata-ops/pipeline/ecs-cluster"
  type  = "String"
  value = aws_ecs_cluster.tomcat_cluster.name
}

resource "aws_ssm_parameter" "ecs_service_name" {
  name  = "/strata-ops/pipeline/ecs-service"
  type  = "String"
  value = aws_ecs_service.tomcat_service.name
}

resource "aws_ssm_parameter" "ecs_task_family" {
  name  = "/strata-ops/pipeline/ecs-task-family"
  type  = "String"
  value = aws_ecs_task_definition.tomcat_definition.family
}


resource "aws_ssm_parameter" "datadog_api_key" {
  name  = "/strata-ops/datadog-api-key"
  type  = "SecureString"
  value = var.datadog_api_key
}