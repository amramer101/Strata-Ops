## Tomcat cluster ----------------------------------------
resource "aws_ecs_cluster" "tomcat_cluster" {
  name = "strata-tomcat-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

## (Task Definition) - Fargate  ---------------------------

resource "aws_ecs_task_definition" "tomcat_definition" {
  family                   = "eprofile-tomcat-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024
  memory                   = 2048
  execution_role_arn       = aws_iam_role.ecs_execution.arn
  task_role_arn            = aws_iam_role.datadog_task_role.arn

  volume {
    name = "dd-sockets"
  }

  container_definitions = jsonencode([

    ## ============ Container 1 - Firelens (لازم يكون أول) ============
    {
      name      = "datadog-log-router"
      image     = "public.ecr.aws/aws-observability/aws-for-fluent-bit:stable"
      cpu       = 64
      memory    = 128
      essential = false

      firelensConfiguration = {
        type = "fluentbit"
        options = {
          "enable-ecs-log-metadata" = "true"
        }
      }

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_tomcat_logs.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "firelens"
        }
      }
    },

    ## ============ Container 2 - Datadog Agent ============
    {
      name      = "datadog-agent"
      image     = "public.ecr.aws/datadog/agent:latest"
      cpu       = 256
      memory    = 512
      essential = false

      environment = [
        {
          name  = "DD_SITE"
          value = "us5.datadoghq.com"
        },
        {
          name  = "DD_APM_ENABLED"
          value = "true"
        },
        {
          name  = "ECS_FARGATE"
          value = "true"
        }
      ]

      secrets = [
        {
          name      = "DD_API_KEY"
          valueFrom = aws_ssm_parameter.datadog_api_key.arn
        }
      ]

      mountPoints = [
        {
          containerPath = "/var/run/datadog"
          sourceVolume  = "dd-sockets"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.ecs_tomcat_logs.name
          "awslogs-region"        = data.aws_region.current.id
          "awslogs-stream-prefix" = "datadog-agent"
        }
      }
    },

    ## ============ Container 3 - App ============
    {
      name      = "vproapp"
      image     = "amrmamer/vprofileapp:latest"
      cpu       = 512
      memory    = 1024
      essential = true

      portMappings = [
        {
          containerPort = 8080
          protocol      = "tcp"
        }
      ]

      secrets = [
        {
          name      = "RDS_PASSWORD"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:parameter/strata-ops/mysql-password"
        },
        {
          name      = "RABBITMQ_PASS"
          valueFrom = "arn:aws:ssm:${data.aws_region.current.id}:${data.aws_caller_identity.current.account_id}:parameter/strata-ops/rabbitmq-password"
        }
      ]

      environment = [
        {
          name  = "RDS_HOSTNAME"
          value = aws_db_instance.RDS.address
        },
        {
          name  = "RDS_DB_NAME"
          value = var.db_name
        },
        {
          name  = "RDS_USERNAME"
          value = var.db_user_name
        },
        {
          name  = "RABBITMQ_HOSTNAME"
          value = split(":", split("//", aws_mq_broker.RabbitMQ.instances[0].endpoints[0])[1])[0]
        },
        {
          name  = "RABBITMQ_USER"
          value = var.rmq_user
        },
        {
          name  = "RABBITMQ_PORT"
          value = "5671"
        },
        {
          name  = "MEMCACHED_HOSTNAME"
          value = aws_elasticache_cluster.ElastiCache.cluster_address
        },
        {
          name  = "DD_TRACE_AGENT_URL"
          value = "unix:///var/run/datadog/apm.socket"
        }
      ]

      mountPoints = [
        {
          containerPath = "/var/run/datadog"
          sourceVolume  = "dd-sockets"
          readOnly      = false
        }
      ]

      logConfiguration = {
        logDriver = "awsfirelens"
        options = {
          Host     = "http-intake.logs.datadoghq.com"
          apikey   = aws_ssm_parameter.datadog_api_key.value
          provider = "ecs"
          Name     = "datadog"
        }
      }
    }
  ])
}

## (ECS Service) --------------------------------------------

resource "aws_ecs_service" "tomcat_service" {
  name                              = "eprofile-tomcat-svc"
  cluster                           = aws_ecs_cluster.tomcat_cluster.id
  task_definition                   = aws_ecs_task_definition.tomcat_definition.arn
  desired_count                     = 2
  launch_type                       = "FARGATE"
  health_check_grace_period_seconds = 600

  network_configuration {
    subnets          = module.vpc.private_subnets
    security_groups  = [aws_security_group.ECS-SG.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = module.alb.target_groups["tomcat_tg"].arn
    container_name   = "vproapp"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [task_definition]
  }
}

## CloudWatch Log Group --------------------------------------------

resource "aws_cloudwatch_log_group" "ecs_tomcat_logs" {
  name              = "/ecs/vprofile-app"
  retention_in_days = 7
}