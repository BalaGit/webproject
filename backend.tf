terraform {
  backend "azurerm" {
    resource_group_name   = "Terraform-RG"
    storage_account_name  = "terraformmyproject"
    container_name        = "terraform-state"
    key                   = "myfdev.tfstate"
  }
}
