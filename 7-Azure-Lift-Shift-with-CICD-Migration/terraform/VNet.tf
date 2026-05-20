module "avm-res-network-virtualnetwork" {
  source = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.14.0"

  address_space = ["10.0.0.0/16"]
  location      = var.region
  name          = "vnet-eprofile-${var.region}-1"
  parent_id     = azurerm_resource_group.eprofile_rg.id
  subnets = {
    "subnet1" = {
      name             = "nginx-subnet-public"
      address_prefixes = ["10.0.0.0/24"]
    }
    "subnet2" = {
      name             = "application-subnet-private"
      address_prefixes = ["10.0.1.0/24"]
    }
    "subnet3" = {
      name             = "backend-subnet-private"
      address_prefixes = ["10.0.2.0/24"]
    }
  }
  tags = {
    environment = "Dev"
    project     = "eProfile"
    managed_by  = "Terraform"
  }
}