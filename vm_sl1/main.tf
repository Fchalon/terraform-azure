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

resource "azurerm_network_security_group" "sl1aionsg" {
  name                = "sl1aionsg"
  location            = "${var.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
}

resource "azurerm_network_security_rule" "ssh" {
  name                       = "SSH"
  priority                   = 100
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range    = "22"
  destination_address_prefix = "*"
   source_address_prefix      = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "smtp" {
  name                       = "SMTP"
  priority                   = 101
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "25"
  destination_address_prefix = "*"
   source_address_prefix      = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "http" {
  name                       = "http"
  priority                   = 201
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "80"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "ntp" {
  name                       = "ntp"
  priority                   = 202
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "123"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "snmpagent" {
  name                       = "SNMP_Agent"
  priority                   = 203
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "161"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "snmptraps" {
  name                       = "SNMP_Traps"
  priority                   = 204
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "162"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_security_rule" "https" {
  name                       = "HTTPS"
  priority                   = 205
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "443"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
    
resource "azurerm_network_security_rule" "syslog" {
  name                       = "Syslog_message"
  priority                   = 206
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Udp"
  source_port_range          = "*"
  destination_port_range     = "514"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
    
resource "azurerm_network_security_rule" "webconf" {
  name                       = "SL1_Web_Configurator"
  priority                   = 207
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "7700"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
    
resource "azurerm_network_security_rule" "phonehome" {
  name                       = "SL1_PhoneHome"
  priority                   = 208
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "7705"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
        
resource "azurerm_network_security_rule" "mysql" {
  name                       = "MySQL"
  priority                   = 209
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "7706"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
        
resource "azurerm_network_security_rule" "datapull" {
  name                       = "Data_Pull"
  priority                   = 210
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "7707"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}
            
resource "azurerm_network_security_rule" "webadmin" {
  name                       = "Admini_Web_Int"
  priority                   = 211
  direction                  = "Inbound"
  access                     = "Allow"
  protocol                   = "Tcp"
  source_port_range          = "*"
  destination_port_range     = "8008"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  resource_group_name         = "${data.azurerm_resource_group.rg.name}"
  network_security_group_name = "${azurerm_network_security_group.sl1aionsg.name}"
}

resource "azurerm_network_interface_security_group_association" "associatesg"{
  network_interface_id      = "${azurerm_network_interface.nic.id}"
  network_security_group_id = "${azurerm_network_security_group.sl1aionsg.id}"
}

resource "azurerm_virtual_machine" "sl1aiovm" {
  name                = "${var.hostname}"
  location            = "${var.location}"
  resource_group_name = "${data.azurerm_resource_group.rg.name}"
  vm_size             = "${var.vm_size}"

  network_interface_ids         = ["${azurerm_network_interface.nic.id}"]
  delete_os_disk_on_termination = "true"

  
  
  storage_os_disk {
    name              = "${var.hostname}-osdisk"
    caching           = "ReadWrite" 
    os_type           = "Linux"
    create_option     = "FromImage"  
    image_uri         = "${var.source_vhd_path}"
    vhd_uri           = "${var.source_vhd_path}-${var.hostname}.vhd"
  }

  os_profile {
    computer_name               = "${var.hostname}"
    admin_username              = "EM7admin"
    admin_password               = "EM7admin"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}