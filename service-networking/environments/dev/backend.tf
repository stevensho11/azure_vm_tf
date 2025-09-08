terraform {
    backend "azurerm" {
        use_azuread_auth = true
        storage_account_name = "azuretfbasicstfstate"
        container_name = "tfstate"
        key = "dev.terraform.service.networking.tfstate"
    }
}