## Variables for Azure Authentication and Configuration From Terraform.tfvars
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

## Region variable
variable "region" {
    default = "spaincentral"
}

variable "resource_group_name" {
    default = "eprofile-resource-group" 
}