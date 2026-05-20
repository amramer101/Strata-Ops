# Service Principal for Terraform to access Azure resources
data "azurerm_client_config" "current" {}

# Azure Key Vault
resource "azurerm_key_vault" "eprofile_kv" {
  name                        = "eprofile-kv-${var.region}-01"
  location                    = var.region
  resource_group_name         = azurerm_resource_group.eprofile_rg.name
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  sku_name                    = "standard"
  
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

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
