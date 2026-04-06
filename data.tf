# Data sources to reference existing infrastructure
data "azurerm_resource_group" "existing" {
  name = var.network_resource_group_name
}

data "azurerm_subnet" "existing" {
  name                 = var.subnet_name
  virtual_network_name = var.virtual_network_name
  resource_group_name  = var.network_resource_group_name
}


# Data source to retrieve admin password from Key Vault
# This will wait for RBAC propagation before attempting to read
data "azurerm_key_vault_secret" "admin_password" {
  name         = var.admin_password.kv_secret_name
  key_vault_id = var.admin_password.key_vault_id
  
  depends_on = [time_sleep.rbac_propagation]
}
