# ==========================================
# EXISTING INFRASTRUCTURE VARIABLES
# ==========================================
# These variables reference existing Azure resources that must already exist

variable "resource_group_name" {
  description = "Name of the existing resource group where VMs will be created"
  type        = string
  default     = "rg-lz-plat-dev4-weu"
}

variable "network_resource_group_name" {
  description = "Name of the resource group containing the existing virtual network"
  type        = string
  default = "rg-lz-plat-dev4-weu"
}

variable "virtual_network_name" {
  description = "Name of the existing virtual network"
  type        = string
  default = "vnet-lz-plat-dev4-weu-connectivity"
}

variable "subnet_name" {
  description = "Name of the existing subnet where VMs will be deployed"
  type        = string
  default = "snet-lz-plat-dev4-weu-connectivity"
}

# ==========================================
# VM DEPLOYMENT CONTROL VARIABLES
# ==========================================
# These variables control which types of VMs to deploy

variable "enable_linux_vm" {
  description = "Enable individual Linux VM deployment"
  type        = bool
  default     = true
}

variable "enable_linux_vm_bulk" {
  description = "Enable Linux VM bulk deployment"
  type        = bool
  default     = false
}

variable "enable_windows_vm" {
  description = "Enable Windows VM bulk deployment"
  type        = bool
  default     = false
}

# ==========================================
# VM CONFIGURATION VARIABLES
# ==========================================
# These variables define the VM specifications and settings
variable "admin_username" {
  description = "Admin username for the virtual machine(s)"
  type        = string
  default     = "azureuser"
}

# ==========================================
# AUTHENTICATION CONFIGURATION
# ==========================================

variable "admin_password" {
 type = object({
   kv_secret_name = string
   key_vault_id = string
 }) 
}

variable "terraform_needs_secret_write_access" {
  description = "Whether Terraform service principal needs write access to Key Vault secrets (for creating/updating secrets)"
  type        = bool
  default     = true
}

# ==========================================
# VM CONFIGURATION VARIABLES
# ==========================================

variable "vm_size" {
  description = "Size of the virtual machine(s)"
  type        = string
  default     = "Standard_B2s"
}

variable "environment" {
  description = "Environment name used in resource naming (e.g., dev, prod, test)"
  type        = string
  default     = "dev"
}

variable "azure_location" {
  description = "Azure location for resources (if different from resource group location)"
  type        = string
  default     = null
}

# ==========================================
# NETWORK CONFIGURATION VARIABLES
# ==========================================
# ==========================================
# NETWORK CONFIGURATION VARIABLES
# ==========================================

variable "enable_public_ip" {
  description = "Whether to create and assign a public IP to the VM (individual Linux VM only)"
  type        = bool
  default     = false
}

variable "private_ip_address" {
  description = "Static private IP address for the VM (leave null for dynamic, individual Linux VM only)"
  type        = string
  default     = null
}

# ==========================================
# SSH & SECURITY CONFIGURATION
# ==========================================
# ==========================================
# SSH & SECURITY CONFIGURATION
# ==========================================

variable "ssh_public_keys" {
  description = "List of SSH public keys for Linux VM authentication"
  type        = list(string)
  default     = []
}

variable "ssh_source_address_prefix" {
  description = "Source address prefix for SSH access (individual Linux VM only)"
  type        = string
  default     = "*"
}

variable "custom_security_rules" {
  description = "List of custom security rules to add to the NSG (individual Linux VM only)"
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

# ==========================================
# STORAGE CONFIGURATION
# ==========================================
# ==========================================
# STORAGE CONFIGURATION
# ==========================================

variable "os_disk_size_gb" {
  description = "Size of the OS disk in GB (individual Linux VM only)"
  type        = number
  default     = null
}

variable "os_disk_storage_account_type" {
  description = "Storage account type for the OS disk (individual Linux VM only)"
  type        = string
  default     = "Premium_LRS"
}

variable "data_disks" {
  description = "List of additional data disks to attach to the VM (individual Linux VM only)"
  type = list(object({
    disk_size_gb         = number
    storage_account_type = string
    caching              = string
  }))
  default = []
}

# ==========================================
# INITIALIZATION & CUSTOMIZATION
# ==========================================

variable "custom_data" {
  description = "Custom data script to run on VM initialization (individual Linux VM only)"
  type        = string
  default     = null
}

# ==========================================
# BULK VM DEPLOYMENT VARIABLES
# ==========================================
# These variables are used for bulk VM deployments (both Linux and Windows)

variable "dc_vm_details" {
  description = "Details for Windows VMs bulk deployment"
  type = map(object({
    workload        = string
    zone            = string
    instance_number = string
  }))
  default = {}
}

variable "linux_vm_details" {
  description = "Details for Linux VMs bulk deployment"
  type = map(object({
    workload        = string
    zone            = string
    instance_number = string
  }))
  default = {}
}

# ==========================================
# RESOURCE TAGGING
# ==========================================

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {
    Environment = "Development"
    CreatedBy   = "Terraform"
  }
}