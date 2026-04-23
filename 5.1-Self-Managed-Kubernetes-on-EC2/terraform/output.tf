## Outputs for the created resources

## K8s Public IP
output "k8s_ip" {
  description = "The public IP of the k8s instance"
  value       = module.ec2_instance_k8s.public_ip
}