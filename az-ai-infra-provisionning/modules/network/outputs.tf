output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}

output "subnet_control_plane_id" {
  value = azurerm_subnet.control_plane.id
}

output "subnet_login_id" {
  value = azurerm_subnet.login.id
}

output "subnet_compute_id" {
  value = azurerm_subnet.compute.id
}

output "subnet_storage_id" {
  value = azurerm_subnet.storage.id
}

output "compute_nsg_id" {
  value = azurerm_network_security_group.compute_nsg.id
}
