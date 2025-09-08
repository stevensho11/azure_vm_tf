data "terraform_remote_state" "networking" {
  backend = "azurerm"
  config = {
    use_azuread_auth     = true
    storage_account_name = "azuretfbasicstfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.service.networking.tfstate"
  }
}

module "vm" {
  source = "../../modules/vm"
  ssh_pub_key = var.ssh_pub_key
  subnet_id = data.terraform_remote_state.networking.outputs.subnet_id
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
}