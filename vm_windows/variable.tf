##############################################################################
# Variables File
##############################################################################

variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "demo"
}

variable "hostname" {
  description = "Virtual machine hostname"
  default     = "windows"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "East US"
}

variable "storage_account_tier" {
  description = "Defines the storage tier."
  default     = "Standard"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_B4ms"
}

variable "image_publisher" {
  description = "Name of the publisher of the image (az vm image list)"
  default     = "MicrosoftWindowsServer"
}

variable "image_offer" {
  description = "Name of the offer (az vm image list)"
  default     = "WindowsServer"
}

variable "image_sku" {
  description = "Image SKU to apply (az vm image list)"
  default     = "2016-Datacenter"
}

variable "image_version" {
  description = "Version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "Administrator user name"
  default     = "azureuser"
}

variable "source_network" {
  description = "Allow access from this network prefix. Defaults to '*'."
  default     = "*"
}

variable "windows_password" {
  description = "admin password "
  default = "Adminwindows1234!"
}