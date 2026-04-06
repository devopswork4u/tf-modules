# Create a NIC
#   Name format (scope: resource group, characters: 2-64 [alphanumerics, _, ., -]): 
resource "azurerm_network_interface" "nic" {
  for_each            = var.vm_details
  name                = "nic${each.value.workload}${var.environment}"
  resource_group_name = var.resource_group_name
  location            = var.location
  tags                = var.tags

  ip_configuration {
    name                          = "ipc${each.value.workload}${var.environment}"
    private_ip_address_allocation = "Dynamic"
    subnet_id                     = var.subnet_id
  }

  lifecycle {
    ignore_changes = [ip_configuration["private_ip_address_allocation"],
    tags["CreatedOn"]]
  }

}

resource "azurerm_windows_virtual_machine" "vm" {
  for_each              = var.vm_details
  name                  = "vm${each.value.workload}${each.value.instance_number}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  admin_password        = var.admin_password
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]
  license_type          = "Windows_Server"
  patch_mode            = "AutomaticByPlatform" # Optional 

  os_disk {
    name                 = "osd${each.value.workload}${var.environment}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition-hotpatch"
    version   = "latest"
  }

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      identity,
    size]
  }

  tags       = var.tags
  depends_on = [azurerm_network_interface.nic]
  zone       = var.use_zone ? each.value.zone : null

}
