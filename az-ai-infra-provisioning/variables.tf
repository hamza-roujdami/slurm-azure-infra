variable "location" {
  description = "Azure region for all resources"
  type        = string
  default     = "francecentral"
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
  default     = "rg-az-ai-infra"
}

variable "name_prefix" {
  description = "Prefix for naming all resources"
  type        = string
  default     = "az-ai-infra"
}

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
  default     = "azureuser"
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "os_disk_sku" {
  description = "SKU for OS disks"
  type        = string
  default     = "StandardSSD_LRS"
}

# Login Node
variable "login_vm_size" {
  description = "VM size for login nodes"
  type        = string
  default     = "Standard_D4s_v3"
}

variable "login_instance_count" {
  description = "Number of login nodes"
  type        = number
  default     = 2
}

# Controller Node
variable "controller_vm_size" {
  description = "VM size for controller node"
  type        = string
  default     = "Standard_D4s_v3"
}

# Compute Nodes
variable "compute_vm_size" {
  description = "VM size for compute nodes"
  type        = string
  default     = "Standard_NC24ads_A100_v4"
}

variable "compute_instance_count" {
  description = "Number of compute nodes"
  type        = number
  default     = 2
}