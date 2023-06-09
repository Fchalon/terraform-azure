variable "prefix" {
  description = "This prefix will be included in the name of some resources."
  default     = "sl1"
}

variable "hostname" {
  description = "Virtual machine hostname"
  default     = "sl1aio"
}

variable "location" {
  description = "The region where the virtual network is created."
  default     = "eastus"
}

variable "vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A2_v2"
}

variable "source_vhd_path" {
  description = "Specifies the URI of the VHD."
  default     = "https://sl1storageaccount.blob.core.windows.net/sl1vhd/em7aio.vhd"
}

