variable "location" {
  description = "Azure region for all resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Azure Resource Group"
  type        = string
}

variable "name_prefix" {
  description = "Prefix for naming all resources"
  type        = string
}

variable "login_vm_size" {
  description = "VM size for login nodes"
  type        = string
}

variable "login_instance_count" {
  description = "Number of login nodes"
  type        = number
}

variable "admin_username" {
  description = "Admin username for all VMs"
  type        = string
}

variable "ssh_public_key_path" {
  description = "Path to the SSH public key"
  type        = string
}

variable "os_disk_sku" {
  description = "SKU for OS disks"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for login nodes"
  type        = string
}
