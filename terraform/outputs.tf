output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_name" {
  value = azurerm_virtual_network.vnet.name
}

output "control_plane_subnet_id" {
  value = azurerm_subnet.control_plane.id
}

output "login_subnet_id" {
  value = azurerm_subnet.login.id
}

output "compute_subnet_id" {
  value = azurerm_subnet.compute.id
}

output "storage_subnet_id" {
  value = azurerm_subnet.storage.id
}

output "login_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.login.id
}

output "controller_vm_id" {
  value = azurerm_linux_virtual_machine.controller.id
}

output "compute_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.compute.id
}

output "compute_nsg_id" {
  value = azurerm_network_security_group.compute_nsg.id
}

output "lustre_id" {
  value = azurerm_managed_lustre_file_system.lustre.id
}