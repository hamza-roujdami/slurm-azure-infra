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
