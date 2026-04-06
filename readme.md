# Azure VM Deployment Terraform Modules

This repository contains Terraform modules for deploying Azure Virtual Machines with automated security and networking configurations.

## 🏗️ What These Modules Do

### Single Linux VM Module
Deploys a fully configured Linux virtual machine with:
- Network security groups and rules
- Optional public IP and private networking
- Data disk attachments
- Boot diagnostics (optional)

### Bulk Linux VM Module
Deploys multiple Linux VMs simultaneously with:
- Shared networking and security configurations
- Scalable deployment patterns
- Consistent naming conventions

### Bulk Windows VM Module  
Deploys multiple Windows VMs for enterprise scenarios:
- Domain-ready configurations
- Bulk provisioning capabilities
- Enterprise security settings

## 🔐 Key Features

- **Secure Authentication**: Integration with Azure Key Vault for password management
- **Single-Command Deployment**: Complete infrastructure provisioning in one command
- **Flexible Networking**: Support for existing VNets and subnets
- **Automated RBAC**: Self-configuring Key Vault permissions
- **No Manual Steps**: Fully automated deployment process

## 🚀 Usage

```bash

# Deploy everything
terraform apply -var-file="terraform.tfvars"
```

## 📁 Structure

- `modules/linux_vm/` - Individual Linux VM deployment
- `modules/linux_vm_bulk/` - Multiple Linux VMs  
- `modules/windows_vm/` - Multiple Windows VMs
- `example-single-deploy.tfvars` - Configuration template
