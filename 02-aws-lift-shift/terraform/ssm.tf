## This file defines AWS SSM Parameters for storing sensitive information such as SonarQube token and Nexus password. 
## The parameters are stored as SecureString to ensure they are encrypted at rest. 
## The lifecycle block is used to ignore changes to the value, allowing you to update the parameters manually without Terraform trying to revert them back to "pending".


resource "aws_ssm_parameter" "sonar_token" {
  name  = "/strata-ops/sonar-token"
  type  = "SecureString"
  value = "pending" 

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "nexus_password" {
  name  = "/strata-ops/nexus-password"
  type  = "SecureString"
  value = "pending"

  lifecycle {
    ignore_changes = [value]
  }
}
