# Terraform on Azure — Best‑Practices Sandbox

This repository is a small, opinionated sandbox for practicing **Terraform on Azure** with production‑style patterns:

- **Modules vs. Environments** directory split
- **One state per root stack** (service × environment) using the **azurerm** backend
- **Remote state** to wire stacks together (e.g., VM reads Networking outputs)
- **Secrets via Doppler** (no plaintext in code)

---

## Repo Layout

```
.
├─ service-networking/
│  ├─ modules/
│  │  └─ network/               # VNet + Subnet (no NICs/VMs here)
│  └─ environments/
│     └─ dev/
│        ├─ backend.tf          # azurerm backend (unique state key)
│        ├─ main.tf             # root stack; re-exports module outputs
│        └─ dev.tfvars          # optional vars for dev
└─ service-vm/
   ├─ modules/
   │  └─ vm/                    # NIC + Linux VM (consumes networking outputs)
   └─ environments/
      └─ dev/
         ├─ backend.tf          # azurerm backend (unique state key)
         ├─ main.tf             # reads remote state from networking
         └─ dev.tfvars          # optional vars for dev
```

**Why this split?**

- `modules/` holds reusable building blocks (no remote state reads here).
- `environments/<env>/` are **root stacks** with their own state objects and CI jobs.

---

## Remote State Contract

Only **root outputs** are visible to other stacks. So:

- **Networking root** (dev) re-exports what others need:

```hcl
# service-networking/environments/dev/main.tf
module "network" { source = "../../modules/network" }

output "resource_group_name" { value = module.network.resource_group_name }
output "vnet_id"            { value = module.network.vnet_id }
output "subnet_id"          { value = module.network.subnet_id }
```

- **VM root** (dev) reads networking’s state and passes values into its module:

```hcl
# service-vm/environments/dev/main.tf
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
  source              = "../../modules/vm"
  resource_group_name = data.terraform_remote_state.networking.outputs.resource_group_name
  subnet_id           = data.terraform_remote_state.networking.outputs.subnet_id
  location            = "East US"
  ssh_pub_key         = var.ssh_pub_key
}
```

---

## State & Backends

Each root stack has its **own** state object in the same storage account/container but with a unique `key`:

```hcl
# service-networking/environments/dev/backend.tf
terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    storage_account_name = "azuretfbasicstfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.service.networking.tfstate"
  }
}
```

```hcl
# service-vm/environments/dev/backend.tf
terraform {
  backend "azurerm" {
    use_azuread_auth     = true
    storage_account_name = "azuretfbasicstfstate"
    container_name       = "tfstate"
    key                  = "dev.terraform.service.vm.tfstate"
  }
}
```

---

## Secrets with Doppler

Secrets (e.g., SSH pub key, custom variables) are injected at runtime with Doppler.
