# Main Terraform configuration file
# This demonstrates how to use the Virtual Machine module

# Configure the Azure Provider
provider "azurerm" {
  features {}
}

# Local values
locals {
  tags = merge(var.tags, {
    ManagedBy = "Terraform"
  })
  
  # Use the created secret if we're managing it, otherwise read from existing secret
  admin_password = var.terraform_needs_secret_write_access && length(azurerm_key_vault_secret.admin_password) > 0 ? azurerm_key_vault_secret.admin_password[0].value : data.azurerm_key_vault_secret.admin_password.value
}

# Naming generator
module "naming" {
  source  = "Azure/naming/azurerm"
  suffix = [ "test" ]
}


# Deploy Linux VM using the module
module "web_server" {
  count               = var.enable_linux_vm == true ? 1 : 0
  source = "./modules/linux_vm"

  # Required variables
  vm_name             = module.naming.linux_virtual_machine.name
  resource_group_name = data.azurerm_resource_group.existing.name
  location           = data.azurerm_resource_group.existing.location
  subnet_id          = data.azurerm_subnet.existing.id
  admin_username     = var.admin_username
  admin_password     = local.admin_password
  # Optional: VM Configuration
  vm_size = var.vm_size
  
  # Optional: Network Configuration
  enable_public_ip = var.enable_public_ip
  private_ip_address = var.private_ip_address
  
  # # SSH Authentication (REQUIRED for secure access)
  # ssh_public_keys = var.ssh_public_keys
  
  # # Optional: Security Configuration
  # ssh_source_address_prefix = var.ssh_source_address_prefix
  
  # Optional: Custom security rules (example for web server)
  custom_security_rules = var.custom_security_rules
  
  # Optional: Storage Configuration
  os_disk_size_gb = var.os_disk_size_gb
  os_disk_storage_account_type = var.os_disk_storage_account_type
  
  # Disable boot diagnostics to avoid creating storage account
  enable_boot_diagnostics = false
  
  # Enable password authentication since we're using Key Vault passwords
  disable_password_authentication = false
  
  # Optional: Additional data disks
  data_disks = var.data_disks
  
  # Optional: Cloud-init script for initial setup
  custom_data = var.custom_data
  
  # Tags
  tags = var.tags
}



# #--[  Windows VMs ]------------------------------------------------------------------------------------------------

module "windows_vm" {
  count               = var.enable_windows_vm == true ? 1 : 0
  source              = "./modules/windows_vm"
  resource_group_name = data.azurerm_resource_group.existing.name
  environment         = var.environment
  vm_details          = var.dc_vm_details
  location            = coalesce(var.azure_location, data.azurerm_resource_group.existing.location)
  admin_username      = var.admin_username
  admin_password      = local.admin_password
  subnet_id           = data.azurerm_subnet.existing.id
  vm_size             = var.vm_size
  tags                = local.tags
}

# #--[  Linux VMs - Bulk Deployment ]------------------------------------------------------------------------------

module "linux_vm_bulk" {
  count               = var.enable_linux_vm_bulk == true ? 1 : 0
  source              = "./modules/linux_vm_bulk"
  resource_group_name = data.azurerm_resource_group.existing.name
  environment         = var.environment
  vm_details          = var.linux_vm_details
  location            = coalesce(var.azure_location, data.azurerm_resource_group.existing.location)
  admin_username      = var.admin_username
  admin_password      = local.admin_password
  subnet_id           = data.azurerm_subnet.existing.id
  vm_size             = var.vm_size
  ssh_public_keys     = var.ssh_public_keys
  tags                = local.tags
}