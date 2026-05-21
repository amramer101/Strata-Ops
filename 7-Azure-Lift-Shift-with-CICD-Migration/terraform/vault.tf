# Service Principal for Terraform to access Azure resources
data "azurerm_client_config" "current" {}

# Azure Key Vault
resource "azurerm_key_vault" "eprofile_kv" {
  name                = "eprofile-kv-weurope-01"
  location            = var.region
  resource_group_name = azurerm_resource_group.eprofile_rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  sku_name            = "standard"

  soft_delete_retention_days = 7
  purge_protection_enabled   = false

  # Access Policy
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Purge", "Recover"
    ]
  }
}

# (MySQL / Database) -----------------------------------------------------------

resource "random_password" "db_password" {
  length  = 8
  special = false
}

resource "azurerm_key_vault_secret" "mysql_username" {
  name         = "mysql-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

resource "azurerm_key_vault_secret" "mysql_password" {
  name         = "mysql-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

# (RabbitMQ) -----------------------------------------------------------

resource "random_password" "rmq_password" {
  length  = 16
  special = false
}

resource "azurerm_key_vault_secret" "rabbitmq_username" {
  name         = "rabbitmq-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

resource "azurerm_key_vault_secret" "rabbitmq_password" {
  name         = "rabbitmq-password"
  value        = random_password.rmq_password.result
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

# (GitHub Actions CI/CD Pipeline Requirements) -------------------------

#  Private IP for Tomcat (App VM)
resource "azurerm_key_vault_secret" "tomcat_private_ip" {
  name         = "tomcat-private-ip"
  value        = azurerm_network_interface.app_nic.private_ip_address
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

# Public IP for Nginx (Bastion/Proxy)
resource "azurerm_key_vault_secret" "nginx_public_ip" {
  name         = "nginx-public-ip"
  value        = azurerm_public_ip.nginx_pip.ip_address
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

# VM Username (used for SSH)
resource "azurerm_key_vault_secret" "pipeline_vm_username" {
  name         = "vm-username"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}

# SSH Private Key (For GitHub Actions to SSH into the VMs)
resource "azurerm_key_vault_secret" "pipeline_ssh_key" {
  name         = "vm-ssh-key"
  value = file("./azure_id_rsa")
  key_vault_id = azurerm_key_vault.eprofile_kv.id
}