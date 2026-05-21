# Private DNS Zone
resource "azurerm_private_dns_zone" "eprofile_dns" {
  name                = "eprofile.az"
  resource_group_name = azurerm_resource_group.eprofile_rg.name
}

# Virtual Network Link
resource "azurerm_private_dns_zone_virtual_network_link" "dns_vnet_link" {
  name                  = "eprofile-dns-vnet-link"
  resource_group_name   = azurerm_resource_group.eprofile_rg.name
  private_dns_zone_name = azurerm_private_dns_zone.eprofile_dns.name
  virtual_network_id    = azurerm_virtual_network.vnet.id

  ## VMs seldom register themselves in the DNS
  registration_enabled = true
}

# ====================================================================

# (A) Records For VMs

# Record For Application
resource "azurerm_private_dns_a_record" "app_record" {
  name                = "app"
  zone_name           = azurerm_private_dns_zone.eprofile_dns.name
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  ttl                 = 300
  records             = [azurerm_network_interface.app_nic.private_ip_address]
}

# Record For Backend
resource "azurerm_private_dns_a_record" "backend_record" {
  name                = "backend"
  zone_name           = azurerm_private_dns_zone.eprofile_dns.name
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  ttl                 = 300
  records             = [azurerm_network_interface.backend_nic.private_ip_address]
}
