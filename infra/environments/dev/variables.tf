variable "arm_client_id" {
  type = string
  description = "Client ID of service principal"
  sensitive = true
}

variable "arm_tenant_id" {
  type = string
  description = "Tenant ID of service principal"
  sensitive = true
}

variable "az_tfstate_container_name" {
  type = string
  description = "Name of container for tfstate"
  sensitive = true
}

variable "az_tfstate_storage_account_name" {
  type = string
  description = "Name of storage account for container of tfstate"
  sensitive = true
}

variable "az_tfstate_key" {
  type = string
  description = "Name of blob that stores tfstate"
  sensitive = true
}

variable "use_azuread_auth" {
  type = bool
  description = "boolean for using azuread auth"
  default = true
}

variable "use_oidc" {
  type = bool
  description = "boolean for using azure oidc"
  default = true
}