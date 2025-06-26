output "compute_vmss_id" {
  value = azurerm_linux_virtual_machine_scale_set.compute.id
}

output "compute_vmss_name" {
  value = azurerm_linux_virtual_machine_scale_set.compute.name
}
