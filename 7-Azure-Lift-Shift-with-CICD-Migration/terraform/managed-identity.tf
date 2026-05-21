
## This file defines the Managed Identities for the VMs and their access policies to the Key Vault.

resource "azurerm_key_vault_access_policy" "app_vm_policy" {
  key_vault_id       = azurerm_key_vault.eprofile_kv.id
  tenant_id          = azurerm_linux_virtual_machine.app_vm.identity[0].tenant_id
  object_id          = azurerm_linux_virtual_machine.app_vm.identity[0].principal_id
  secret_permissions = ["Get", "List"]
}


resource "azurerm_key_vault_access_policy" "backend_vm_policy" {
  key_vault_id       = azurerm_key_vault.eprofile_kv.id
  tenant_id          = azurerm_linux_virtual_machine.backend_vm.identity[0].tenant_id
  object_id          = azurerm_linux_virtual_machine.backend_vm.identity[0].principal_id
  secret_permissions = ["Get", "List"]
}
