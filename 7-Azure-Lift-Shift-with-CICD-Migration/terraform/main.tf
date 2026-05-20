resource "azurerm_resource_group" "eprofile_rg" {
  name     = var.resource_group_name
  location = var.region

  tags = {
    environment = "Dev"
    project     = "eProfile"
    managed_by  = "Terraform"
  }
}