terraform {
  required_version = ">=1.1.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source              = "./modules/network"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  name_prefix         = var.name_prefix
}

module "compute" {
  source                = "./modules/compute"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  name_prefix           = var.name_prefix
  compute_vm_size       = var.compute_vm_size
  compute_instance_count = var.compute_instance_count
  admin_username        = var.admin_username
  ssh_public_key_path   = var.ssh_public_key_path
  os_disk_sku           = var.os_disk_sku
  subnet_id             = module.network.subnet_compute_id
}

module "controller" {
  source                = "./modules/controller"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  name_prefix           = var.name_prefix
  controller_vm_size    = var.controller_vm_size
  admin_username        = var.admin_username
  ssh_public_key_path   = var.ssh_public_key_path
  os_disk_sku           = var.os_disk_sku
  subnet_id             = module.network.subnet_compute_id
}

module "login" {
  source                = "./modules/login"
  location              = var.location
  resource_group_name   = azurerm_resource_group.rg.name
  name_prefix           = var.name_prefix
  login_vm_size         = var.login_vm_size
  login_instance_count  = var.login_instance_count
  admin_username        = var.admin_username
  ssh_public_key_path   = var.ssh_public_key_path
  os_disk_sku           = var.os_disk_sku
  subnet_id             = module.network.subnet_login_id
}

module "lustre" {
  source                        = "./modules/lustre"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.rg.name
  name_prefix                   = var.name_prefix
  storage_capacity_in_tb        = 48
  sku_name                      = "AMLFS-Durable-Premium-40"
  subnet_id                     = module.network.subnet_storage_id
  zones                         = ["1"]
  maintenance_day_of_week       = "Sunday"
  maintenance_time_of_day_in_utc = "00:00"
}