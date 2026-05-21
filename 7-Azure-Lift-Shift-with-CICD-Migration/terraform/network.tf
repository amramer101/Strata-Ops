# VNet
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-eprofile-${var.region}-1"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  address_space       = ["10.0.0.0/16"]

  tags = {
    environment = "Dev"
    project     = "eProfile"
    managed_by  = "Terraform"
  }
}

# Nginx Subnet (Public)
resource "azurerm_subnet" "subnet1" {
  name                 = "nginx-subnet-public"
  resource_group_name  = azurerm_resource_group.eprofile_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

# Application Subnet (Private)
resource "azurerm_subnet" "subnet2" {
  name                 = "application-subnet-private"
  resource_group_name  = azurerm_resource_group.eprofile_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Backend Subnet (Private)
resource "azurerm_subnet" "subnet3" {
  name                 = "backend-subnet-private"
  resource_group_name  = azurerm_resource_group.eprofile_rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}