# Azure Managed Lustre File System
resource "azurerm_managed_lustre_file_system" "lustre" {
  name                = "${var.name_prefix}-lustre"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  storage_capacity_in_tb = 48  # Minimum required for AMLFS-Durable-Premium-40
  sku_name           = "AMLFS-Durable-Premium-40"
  subnet_id          = azurerm_subnet.storage.id
  zones              = ["1", "2", "3"]  # Required for zone-redundant storage

  maintenance_window {
    day_of_week        = "Sunday"
    time_of_day_in_utc = "00:00"
  }
}