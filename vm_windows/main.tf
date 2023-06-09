##############################################################################
# Define providers and ressources
##############################################################################
# Azure Provider source and version being used

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=1.22.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

# The resource group ,virtual network and subnet are defined
data "azurerm_resource_group" "rg" {
  name = "rg-fabrykpoc1-core-kcl-eastus-002"
}

data "azurerm_virtual_network" "tf-vnet" {
  name = "vnet-rg-fabrykpoc1-core-kcl-eastus-002"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

data "azurerm_subnet" "tf-subnet" {
  name                 = "services"
  virtual_network_name = "${data.azurerm_virtual_network.tf-vnet.name}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
}

# managed disk
resource "azurerm_managed_disk" "disk" {
  name                 = "${var.hostname}_datadisk_0"
  location             = "${var.location}"
  resource_group_name  = "${data.azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 15
}

##############################################################################
# Build an windows servers 2016 windows VM
##############################################################################

resource "azurerm_network_interface" "nic" {
  name                      = "${var.prefix}-nic"
  location                  = "${var.location}"
  resource_group_name       = "${data.azurerm_resource_group.rg.name}"
  ip_configuration {
    name                          = "${var.prefix}ipconfig"
    subnet_id                     = "${data.azurerm_subnet.tf-subnet.id}"
    private_ip_address_allocation = "Dynamic"
  }
}

# Security group to allow inbound access on port 3389 (RDP)
resource "azurerm_network_security_group" "sg" {
  name                  = "${var.prefix}-sg"
  location              = "${var.location}"
  resource_group_name   = "${data.azurerm_resource_group.rg.name}"
  security_rule {
    name                       = "RDP"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "${var.source_network}"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "associatesg"{
  network_interface_id      = "${azurerm_network_interface.nic.id}"
  network_security_group_id = "${azurerm_network_security_group.sg.id}"
}

resource "azurerm_virtual_machine" "site" {
  name                = "${var.hostname}-VM"
  location            = "${var.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  vm_size             = "${var.vm_size}"
  network_interface_ids         = ["${azurerm_network_interface.nic.id}"]
  delete_os_disk_on_termination = "true"
  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }
  storage_os_disk {
    name              = "${var.hostname}-osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }
  storage_data_disk {
    name              = "${azurerm_managed_disk.disk.name}"
    managed_disk_id   = "${azurerm_managed_disk.disk.id}"
    disk_size_gb      = "${azurerm_managed_disk.disk.disk_size_gb}"
    create_option     = "Attach"
    lun               = 0
  }
  os_profile {
    computer_name = "${var.hostname}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.windows_password}"
  }
  os_profile_windows_config { 
    provision_vm_agent = true
  }
}