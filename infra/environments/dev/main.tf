module "dev_vm" {
    source = "../../modules/azure_vm"
    ssh_pub_key = var.ssh_pub_key
}