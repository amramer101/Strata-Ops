module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"

  name    = "eprofile-alb"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.public_subnets

  enable_deletion_protection = false


  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }
  security_group_egress_rules = {
    to_ecs = {
      from_port   = 8080
      to_port     = 8080
      ip_protocol = "tcp"
      cidr_ipv4   = "10.0.0.0/16"
    }
  }
  
  listeners = {
    http_traffic = {
      port     = 80
      protocol = "HTTP"
      forward = {
        target_group_key = "tomcat_tg"
      }
    }
  }

  target_groups = {
    tomcat_tg = {
      name_prefix       = "vpro-"
      protocol          = "HTTP"
      port              = 8080
      target_type       = "ip"
      create_attachment = false

    health_check = {
      enabled             = true
      path                = "/"
      port                = "traffic-port"
      healthy_threshold   = 2
      unhealthy_threshold = 5
      timeout             = 10
      interval            = 30
    }
    }
  }

  tags = {
    Environment = "Production"
    Project     = "Strata-Ops"
  }
}