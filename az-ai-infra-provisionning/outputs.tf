output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "control_plane_subnet_id" {
  value = module.network.subnet_control_plane_id
}

output "login_subnet_id" {
  value = module.network.subnet_login_id
}

output "compute_subnet_id" {
  value = module.network.subnet_compute_id
}

output "storage_subnet_id" {
  value = module.network.subnet_storage_id
}

output "login_vmss_id" {
  value = module.login.login_vmss_id
}

output "controller_vm_id" {
  value = module.controller.controller_vm_id
}

output "compute_vmss_id" {
  value = module.compute.compute_vmss_id
}

output "compute_nsg_id" {
  value = module.network.compute_nsg_id
}

output "lustre_id" {
  value = module.lustre.lustre_id
}