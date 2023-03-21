terraform {
  required_providers {
    azurerm = {
      version = "~> 3.48.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "hub"
  subscription_id = var.connectivity_sub
  features {}
}
