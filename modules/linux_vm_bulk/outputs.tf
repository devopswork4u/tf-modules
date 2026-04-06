# Outputs for Linux VM Bulk deployment module

output "vm_ids" {
  description = "Map of VM IDs"
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm : key => vm.id
  }
}

output "vm_names" {
  description = "Map of VM names"
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm : key => vm.name
  }
}

output "private_ip_addresses" {
  description = "Map of private IP addresses"
  value = {
    for key, nic in azurerm_network_interface.nic : key => nic.private_ip_address
  }
}

output "network_interface_ids" {
  description = "Map of network interface IDs"
  value = {
    for key, nic in azurerm_network_interface.nic : key => nic.id
  }
}

output "vm_details_output" {
  description = "Complete VM details for reference"
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm : key => {
      id                 = vm.id
      name              = vm.name
      location          = vm.location
      size              = vm.size
      admin_username    = vm.admin_username
      private_ip        = azurerm_network_interface.nic[key].private_ip_address
      network_interface = azurerm_network_interface.nic[key].id
      zone              = vm.zone
    }
  }
}
