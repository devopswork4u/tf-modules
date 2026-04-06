# Required Variables
variable "vm_name" {
  description = "Name of the virtual machine"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "subnet_id" {
  description = "ID of the existing subnet where the VM will be deployed"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machine"
  type        = string
}

# Optional Variables with defaults
variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
  default     = "Standard_B2s"
}

variable "enable_public_ip" {
  description = "Whether to create and assign a public IP to the VM"
  type        = bool
  default     = false
}

variable "private_ip_address" {
  description = "Static private IP address for the VM (leave null for dynamic)"
  type        = string
  default     = null
}

variable "ssh_public_keys" {
  description = "List of SSH public keys for authentication"
  type        = list(string)
  default     = []
}

variable "disable_password_authentication" {
  description = "Whether to disable password authentication (recommended: true)"
  type        = bool
  default     = true
}

variable "admin_password" {
  description = "Admin password for the VM (only used if password authentication is enabled)"
  type        = string
  default     = null
  sensitive   = true
}

variable "ssh_source_address_prefix" {
  description = "Source address prefix for SSH access (use * for any, or specify CIDR)"
  type        = string
  default     = "*"
}

variable "custom_security_rules" {
  description = "List of custom security rules to add to the NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = []
}

variable "os_disk_caching" {
  description = "Caching type for the OS disk"
  type        = string
  default     = "ReadWrite"
  validation {
    condition     = contains(["None", "ReadOnly", "ReadWrite"], var.os_disk_caching)
    error_message = "OS disk caching must be None, ReadOnly, or ReadWrite."
  }
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk"
  type        = string
  default     = "Premium_LRS"
  validation {
    condition     = contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS"], var.os_disk_storage_account_type)
    error_message = "OS disk storage account type must be Standard_LRS, StandardSSD_LRS, or Premium_LRS."
  }
}

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB"
  type        = number
  default     = null
}

variable "source_image_reference" {
  description = "Source image reference for the VM"
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "enable_boot_diagnostics" {
  description = "Whether to enable boot diagnostics"
  type        = bool
  default     = true
}

variable "custom_data" {
  description = "Custom data script to run on VM initialization"
  type        = string
  default     = null
}

variable "data_disks" {
  description = "List of additional data disks to attach to the VM"
  type = list(object({
    disk_size_gb         = number
    storage_account_type = string
    caching              = string
  }))
  default = []
  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["None", "ReadOnly", "ReadWrite"], disk.caching)
    ])
    error_message = "Data disk caching must be None, ReadOnly, or ReadWrite."
  }
  validation {
    condition = alltrue([
      for disk in var.data_disks : contains(["Standard_LRS", "StandardSSD_LRS", "Premium_LRS", "UltraSSD_LRS"], disk.storage_account_type)
    ])
    error_message = "Data disk storage account type must be Standard_LRS, StandardSSD_LRS, Premium_LRS, or UltraSSD_LRS."
  }
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
