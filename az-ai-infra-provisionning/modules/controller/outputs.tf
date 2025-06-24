output "controller_vm_id" {
  value = azurerm_linux_virtual_machine.controller.id
}

output "controller_private_ip" {
  value = azurerm_network_interface.controller_nic.private_ip_address
}
