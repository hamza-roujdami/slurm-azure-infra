# Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet-${var.name_prefix}-infra"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

# Subnets
resource "azurerm_subnet" "control_plane" {
  name                 = "subnet-${var.name_prefix}-control"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "login" {
  name                 = "subnet-${var.name_prefix}-login"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "compute" {
  name                 = "subnet-${var.name_prefix}-compute"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

resource "azurerm_subnet" "storage" {
  name                 = "subnet-${var.name_prefix}-lustre"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.4.0/24"]
}

# Network Security Groups
resource "azurerm_network_security_group" "compute_nsg" {
  name                = "nsg-${var.name_prefix}-compute"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range         = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "compute" {
  subnet_id                 = azurerm_subnet.compute.id
  network_security_group_id = azurerm_network_security_group.compute_nsg.id
}
