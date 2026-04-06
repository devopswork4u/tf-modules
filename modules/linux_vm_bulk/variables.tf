# Variables for Linux VM Bulk deployment module
# This module follows the same pattern as the Windows VM module but for Linux VMs

variable "resource_type" {
  description = "Resource type identifier"
  type        = string
  default     = "vm"
}

variable "vm_size" {
  description = "Size of the virtual machines"
  type        = string
}

variable "admin_username" {
  description = "Admin username for the virtual machines"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "admin_password" {
  description = "Admin password for the VMs (only used if password authentication is enabled)"
  type        = string
  default     = null
  sensitive   = true
}

variable "subnet_id" {
  description = "ID of the existing subnet where VMs will be deployed"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "use_zone" {
  description = "Whether to use availability zones"
  type        = bool
  default     = true
}

variable "vm_details" {
  description = "Map of VM details for bulk deployment"
  type = map(object({
    workload        = string
    zone            = string
    instance_number = string
  }))
}

variable "environment" {
  description = "Environment name (used in resource naming)"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where VMs will be created"
  type        = string
}

variable "disable_password_authentication" {
  description = "Whether to disable password authentication (recommended: true for Linux)"
  type        = bool
  default     = true
}

variable "ssh_public_keys" {
  description = "List of SSH public keys for authentication"
  type        = list(string)
  default     = []
}

variable "source_image_reference" {
  description = "Source image reference for the VMs"
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
