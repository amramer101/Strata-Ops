# NAT Gateway
resource "azurerm_public_ip" "nat_pip" {
  name                = "nat-gateway-pip"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NAT Gateway
resource "azurerm_nat_gateway" "nat_gw" {
  name                    = "eprofile-nat-gateway"
  location                = var.region
  resource_group_name     = azurerm_resource_group.eprofile_rg.name
  sku_name                = "Standard"
  idle_timeout_in_minutes = 4
}

# IP Association
resource "azurerm_nat_gateway_public_ip_association" "nat_pip_assoc" {
  nat_gateway_id       = azurerm_nat_gateway.nat_gw.id
  public_ip_address_id = azurerm_public_ip.nat_pip.id
}


# Associate NAT Gateway with Subnets (Application and Backend)
resource "azurerm_subnet_nat_gateway_association" "app_subnet_nat" {
  subnet_id      = module.avm-res-network-virtualnetwork.subnets["subnet2"].id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}

resource "azurerm_subnet_nat_gateway_association" "backend_subnet_nat" {
  subnet_id      = module.avm-res-network-virtualnetwork.subnets["subnet3"].id
  nat_gateway_id = azurerm_nat_gateway.nat_gw.id
}