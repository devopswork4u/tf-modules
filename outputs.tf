# Root level outputs from the VM deployments

# Individual Linux VM outputs (only when enabled)
output "linux_vm_info" {
  description = "Individual Linux VM information"
  value = var.enable_linux_vm ? {
    vm_id              = module.web_server[0].vm_id
    vm_name            = module.web_server[0].vm_name
    private_ip_address = module.web_server[0].vm_private_ip_address
    public_ip_address  = module.web_server[0].vm_public_ip_address
    ssh_command        = module.web_server[0].ssh_connection_command
  } : null
}

output "linux_vm_network_info" {
  description = "Individual Linux VM network configuration"
  value = var.enable_linux_vm ? {
    network_interface_id      = module.web_server[0].network_interface_id
    network_security_group_id = module.web_server[0].network_security_group_id
    public_ip_id             = module.web_server[0].public_ip_id
  } : null
}

output "linux_vm_storage_info" {
  description = "Individual Linux VM storage configuration"
  value = var.enable_linux_vm ? {
    boot_diagnostics_storage_account_id = module.web_server[0].boot_diagnostics_storage_account_id
    data_disk_ids                      = module.web_server[0].data_disk_ids
  } : null
}

# Windows VM bulk outputs (only when enabled)
output "windows_vm_bulk_info" {
  description = "Windows VMs bulk deployment information"
  value = var.enable_windows_vm ? {
    vm_ids                = module.windows_vm[0].vm_ids
    vm_names             = module.windows_vm[0].vm_names
    private_ip_addresses = module.windows_vm[0].private_ip_addresses
    vm_details_output    = module.windows_vm[0].vm_details_output
  } : null
}

# Linux VM bulk outputs (only when enabled)
output "linux_vm_bulk_info" {
  description = "Linux VMs bulk deployment information"
  value = var.enable_linux_vm_bulk ? {
    vm_ids                = module.linux_vm_bulk[0].vm_ids
    vm_names             = module.linux_vm_bulk[0].vm_names
    private_ip_addresses = module.linux_vm_bulk[0].private_ip_addresses
    vm_details_output    = module.linux_vm_bulk[0].vm_details_output
  } : null
}

# Summary output for deployment overview
output "deployment_summary" {
  description = "Summary of all deployed resources"
  value = {
    linux_vm_enabled      = var.enable_linux_vm
    linux_vm_bulk_enabled = var.enable_linux_vm_bulk
    windows_vm_enabled    = var.enable_windows_vm
    
    linux_vm_count       = var.enable_linux_vm ? 1 : 0
    linux_vm_bulk_count  = var.enable_linux_vm_bulk ? length(var.linux_vm_details) : 0
    windows_vm_count     = var.enable_windows_vm ? length(var.dc_vm_details) : 0
    
    total_vms_deployed   = (
      (var.enable_linux_vm ? 1 : 0) +
      (var.enable_linux_vm_bulk ? length(var.linux_vm_details) : 0) +
      (var.enable_windows_vm ? length(var.dc_vm_details) : 0)
    )
  }
}