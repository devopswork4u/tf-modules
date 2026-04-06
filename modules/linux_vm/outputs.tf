# VM Outputs
output "vm_id" {
  description = "ID of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.id
}

output "vm_name" {
  description = "Name of the virtual machine"
  value       = azurerm_linux_virtual_machine.vm.name
}

output "vm_private_ip_address" {
  description = "Private IP address of the virtual machine"
  value       = azurerm_network_interface.vm_nic.private_ip_address
}

output "vm_public_ip_address" {
  description = "Public IP address of the virtual machine (if enabled)"
  value       = var.enable_public_ip ? azurerm_public_ip.vm_public_ip[0].ip_address : null
}

output "vm_public_ip_fqdn" {
  description = "FQDN of the public IP (if enabled)"
  value       = var.enable_public_ip ? azurerm_public_ip.vm_public_ip[0].fqdn : null
}

# Network Outputs
output "network_interface_id" {
  description = "ID of the network interface"
  value       = azurerm_network_interface.vm_nic.id
}

output "network_security_group_id" {
  description = "ID of the network security group"
  value       = azurerm_network_security_group.vm_nsg.id
}

output "public_ip_id" {
  description = "ID of the public IP (if enabled)"
  value       = var.enable_public_ip ? azurerm_public_ip.vm_public_ip[0].id : null
}

# SSH Connection Information
output "ssh_connection_command" {
  description = "SSH command to connect to the VM"
  value = var.enable_public_ip ? (
    length(var.ssh_public_keys) > 0 ? 
      "ssh ${var.admin_username}@${azurerm_public_ip.vm_public_ip[0].ip_address}" : 
      "SSH keys not configured"
  ) : (
    length(var.ssh_public_keys) > 0 ? 
      "ssh ${var.admin_username}@${azurerm_network_interface.vm_nic.private_ip_address} # Connect from within the network" : 
      "SSH keys not configured"
  )
}

# Storage Outputs
output "boot_diagnostics_storage_account_id" {
  description = "ID of the boot diagnostics storage account (if enabled)"
  value       = var.enable_boot_diagnostics ? azurerm_storage_account.vm_storage_account[0].id : null
}

output "data_disk_ids" {
  description = "IDs of the attached data disks"
  value       = [for disk in azurerm_managed_disk.data_disks : disk.id]
}
