# Private DNS Zone
resource "azurerm_private_dns_zone" "eprofile_dns" {
  name                = "eprofile.local"
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

# Record For Database
resource "azurerm_private_dns_a_record" "db_record" {
  name                = "db"
  zone_name           = azurerm_private_dns_zone.eprofile_dns.name
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  ttl                 = 300
  records             = [azurerm_network_interface.db_nic.private_ip_address]
}

# Record For Memcached
resource "azurerm_private_dns_a_record" "memcached_record" {
  name                = "memcached"
  zone_name           = azurerm_private_dns_zone.eprofile_dns.name
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  ttl                 = 300
  records             = [azurerm_network_interface.memcached_nic.private_ip_address]
}

# Record For RabbitMQ
resource "azurerm_private_dns_a_record" "rabbitmq_record" {
  name                = "rabbitmq"
  zone_name           = azurerm_private_dns_zone.eprofile_dns.name
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  ttl                 = 300
  records             = [azurerm_network_interface.rabbitmq_nic.private_ip_address]
}