# Compute Nodes VMSS
resource "azurerm_linux_virtual_machine_scale_set" "compute" {
  name                = "${var.name_prefix}-compute-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                = var.compute_vm_size
  instances          = var.compute_instance_count
  admin_username     = var.admin_username
  zones               = ["2", "3"]

  network_interface {
    name    = "primary"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.compute.id
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
              apt-get install -y slurmd slurm-client
              EOF
  )
}