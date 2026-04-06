# Get current client configuration for Terraform service principal
data "azurerm_client_config" "current" {}

# Get Key Vault resource for RBAC assignment
data "azurerm_key_vault" "existing" {
  name                = regex("vaults/([^/]+)", var.admin_password.key_vault_id)[0]
  resource_group_name = regex("resourceGroups/([^/]+)", var.admin_password.key_vault_id)[0]
}

# Grant Terraform service principal "Key Vault Secrets User" role
resource "azurerm_role_assignment" "kv_terraform_secrets_user" {
  scope                = data.azurerm_key_vault.existing.id
  role_definition_name = "Key Vault Secrets User"
  principal_id         = data.azurerm_client_config.current.object_id
  
  # Add description for clarity
  description = "Terraform service principal access to read Key Vault secrets for VM passwords"
}

# Grant "Key Vault Secrets Officer" if Terraform needs to create/update secrets
resource "azurerm_role_assignment" "kv_terraform_secrets_officer" {
  count                = var.terraform_needs_secret_write_access ? 1 : 0
  scope                = data.azurerm_key_vault.existing.id
  role_definition_name = "Key Vault Secrets Officer"
  principal_id         = data.azurerm_client_config.current.object_id
  
  description = "Terraform service principal access to create/update Key Vault secrets"
}

# Generate a secure random password
resource "random_password" "admin_password" {
  length  = 16
  min_lower = 1
  min_upper = 1
  min_numeric = 1
  min_special = 1
}

# Store the password in Key Vault (only if we need write access)
resource "azurerm_key_vault_secret" "admin_password" {
  count        = var.terraform_needs_secret_write_access ? 1 : 0
  name         = var.admin_password.kv_secret_name
  value        = random_password.admin_password.result
  key_vault_id = var.admin_password.key_vault_id
  
  depends_on = [azurerm_role_assignment.kv_terraform_secrets_officer]
}

# Add a time delay to allow for RBAC propagation
resource "time_sleep" "rbac_propagation" {
  depends_on = [
    azurerm_role_assignment.kv_terraform_secrets_user,
    azurerm_role_assignment.kv_terraform_secrets_officer
  ]
  
  create_duration = "60s"
}