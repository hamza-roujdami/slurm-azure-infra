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

variable "storage_capacity_in_tb" {
  description = "Storage capacity in TB for Lustre file system"
  type        = number
}

variable "sku_name" {
  description = "SKU name for Lustre file system"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for Lustre file system"
  type        = string
}

variable "zones" {
  description = "Zones for Lustre file system"
  type        = list(string)
}

variable "maintenance_day_of_week" {
  description = "Day of week for maintenance window"
  type        = string
}

variable "maintenance_time_of_day_in_utc" {
  description = "Time of day in UTC for maintenance window"
  type        = string
}
