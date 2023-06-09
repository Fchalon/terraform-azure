terraform {
  backend "azurerm" {
    resource_group_name  = "rg-fabrykpoc1-core-kcl-eastus-002"
    storage_account_name = "winvmstorageacount"
    container_name       = "logs"
    key                  = "test.terraform.tfstate"
  }
}