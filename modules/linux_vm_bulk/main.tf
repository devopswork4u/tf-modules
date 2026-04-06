# Create a NIC
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

resource "azurerm_linux_virtual_machine" "vm" {
  for_each              = var.vm_details
  name                  = "vm${each.value.workload}${each.value.instance_number}"
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.vm_size
  admin_username        = var.admin_username
  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  # Disable password authentication by default
  disable_password_authentication = var.disable_password_authentication

  # Admin password (only if password authentication is enabled)
  admin_password = var.admin_password

  os_disk {
    name                 = "osd${each.value.workload}${var.environment}"
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = var.source_image_reference.publisher
    offer     = var.source_image_reference.offer
    sku       = var.source_image_reference.sku
    version   = var.source_image_reference.version
  }

  # SSH Keys (required if password authentication is disabled)
  dynamic "admin_ssh_key" {
    for_each = var.ssh_public_keys
    content {
      username   = var.admin_username
      public_key = admin_ssh_key.value
    }
  }

  lifecycle {
    ignore_changes = [
      tags["CreatedOn"],
      size
    ]
  }

  tags       = var.tags
  depends_on = [azurerm_network_interface.nic]
  zone       = var.use_zone ? each.value.zone : null
}
