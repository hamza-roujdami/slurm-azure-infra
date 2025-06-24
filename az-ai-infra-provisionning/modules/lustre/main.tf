resource "azurerm_managed_lustre_file_system" "lustre" {
  name                = "fs-${var.name_prefix}-lustre"
  resource_group_name = var.resource_group_name
  location            = var.location
  storage_capacity_in_tb = var.storage_capacity_in_tb
  sku_name           = var.sku_name
  subnet_id          = var.subnet_id
  zones              = var.zones

  maintenance_window {
    day_of_week        = var.maintenance_day_of_week
    time_of_day_in_utc = var.maintenance_time_of_day_in_utc
  }
}
