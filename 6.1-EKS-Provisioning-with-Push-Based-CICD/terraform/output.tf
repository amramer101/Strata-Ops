
## Outputs for the created resources

### RDS Endpoint

output "rds_endpoint" {
  value = aws_db_instance.RDS.address
}


## ElastiCache Endpoint
output "elasticache_endpoint" {
  value = aws_elasticache_cluster.ElastiCache.configuration_endpoint
}

## RabbitMQ Endpoint
output "mq_endpoint" {
  description = "The endpoint for RabbitMQ Broker"
  value       = aws_mq_broker.RabbitMQ.instances.0.endpoints
}

## Bastion Host Public IP
output "bastion_ip" {
  description = "The public IP of the Bastion host"
  value       = aws_instance.bastion[0].public_ip
}

## ALB DNS Name
output "ALB" {
  description = "The DNS name of the ALB"
  value       = helm_release.alb_controller.status[0].load_balancer[0].ingress[0].hostname  
}

## GitHub Actions OIDC Role ARN
output "github_role_arn" {
  value       = aws_iam_role.github_actions.arn
  description = "The ARN of the IAM Role for GitHub Actions (Use this in your GitHub Actions workflow to assume the role)"
}