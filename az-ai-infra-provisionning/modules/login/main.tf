resource "azurerm_linux_virtual_machine_scale_set" "login" {
  name                = "vmss-${var.name_prefix}-login"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.login_vm_size
  instances           = var.login_instance_count
  admin_username      = var.admin_username

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = var.subnet_id
    }
  }

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.ssh_public_key_path)
  }

  source_image_reference {
    publisher = "microsoft-dsvm"
    offer     = "ubuntu-hpc"
    sku       = "2204"
    version   = "latest"
  }

  os_disk {
    storage_account_type = var.os_disk_sku
    caching             = "ReadWrite"
  }

  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt-get update
              apt-get install -y slurm-client
              EOF
  )
}
