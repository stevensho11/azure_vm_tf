variable "ssh_pub_key" {
  type = string
  description = "Public key for the VM"
  sensitive = true
}

variable "resource_group_name" {
  type = string
  description = "Name of the resource group created in service-networking module (output)"
  sensitive = true
}

variable "subnet_id" {
  type = string
  description = "ID of the subnet created in service-networking module (output)"
  sensitive = true
}