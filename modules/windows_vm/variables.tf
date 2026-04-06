# Variables for Windows VM module

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
  description = "Admin password for Windows VMs"
  type        = string
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
