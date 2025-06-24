resource "azurerm_network_interface" "controller_nic" {
  name                = "nic-${var.name_prefix}-controller"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_linux_virtual_machine" "controller" {
  name                = "vm-${var.name_prefix}-controller"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.controller_vm_size
  admin_username      = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.controller_nic.id,
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = var.os_disk_sku
  }

  source_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "ubuntu-hpc"
    sku       = "2204"
    version   = "latest"
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y slurmctld
              EOF
  )
}
