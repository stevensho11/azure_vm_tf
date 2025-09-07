terraform {
    backend "azurerm" {
        use_oidc = var.use_oidc
        use_azuread_auth = var.use_azuread_auth
        tenant_id = var.arm_tenant_id
        client_id = var.arm_client_id
        storage_account_name = var.az_tfstate_storage_account_name
        container_name = var.az_tfstate_container_name
        key = var.az_tfstate_key
    }
}