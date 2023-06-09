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
  backend "local" {
    path = ".state/terraform.tfstate"
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

# The public key is also defined

data "azurerm_ssh_public_key" "key" {
  name                = "FRADO"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}


##############################################################################
# Build an Ubuntu 18.04 Linux VM
##############################################################################
# Now that we have a network, we'll deploy an Ubuntu 18.04 Linux server.
# A network interface.
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

# And finally we build our virtual machine. This is a standard Ubuntu instance.

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
  
  os_profile {
    computer_name  = "${var.hostname}"
    admin_username = "${var.admin_username}"
  }
  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${data.azurerm_ssh_public_key.key.public_key}"
    }
  }  
}
