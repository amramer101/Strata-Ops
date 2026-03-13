## Outputs for the created resources

## Docker Public IP
output "docker_ip" {
  description = "The public IP of the Docker instance"
  value       = module.ec2_instance_docker.public_ip
}