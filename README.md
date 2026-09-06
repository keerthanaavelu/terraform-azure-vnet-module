terraform-azure-vnet-module

A reusable Terraform module (Azure VNet + Subnet + NSG) built to demonstrate safe module versioning for shared infrastructure.

Show Image Show Image Show Image

💡 The Problem

Shared Terraform modules used by multiple teams create a hidden trap: without version pinning, every consumer is silently coupled to "latest." One change breaks everyone, instantly.

This repo proves it — then fixes it.

🔥 What Happened
Step	Result
Two environments (dev, staging) consume this module with no version pin	Both work fine
A breaking change is pushed to main (single NSG rule → flexible rule list)	dev fails instantly with Unsupported argument — despite zero changes to its own code
Module tagged as v1.0.0 (old) and v1.1.0 (new); dev pinned to v1.0.0	terraform plan → "No changes." Fully recovered, permanently insulated
staging pinned to v1.1.0, adopts the new rule list format	Clean, expected update — new feature adopted independently

Result: two consumers, two module versions, zero coupling.

📦 What's Inside
Azure Virtual Network + Subnet
Network Security Group with one or more inbound rules
NSG–Subnet association
🏷️ Versions
Version	Interface
v1.0.0	Single rule via flat variables (nsg_rule_name, nsg_rule_priority, nsg_rule_port, nsg_rule_source_address_prefix)
v1.1.0	Multiple rules via nsg_rules list (list(object({...}))) using a dynamic block

Full migration notes → CHANGELOG.md

🚀 Usage

v1.1.0 (current)

hcl
module "vnet" {
  source = "git::https://github.com/keerthanaavelu/terraform-azure-vnet-module.git?ref=v1.1.0"

  resource_group_name = "rg-staging-vnet"
  vnet_name            = "vnet-staging"
  address_space        = ["10.1.0.0/16"]
  subnet_name          = "subnet-staging"
  subnet_prefix        = ["10.1.1.0/24"]
  nsg_name             = "nsg-staging"

  nsg_rules = [
    { name = "allow-https", priority = 100, destination_port_range = "443", source_address_prefix = "*" },
    { name = "allow-http",  priority = 110, destination_port_range = "80",  source_address_prefix = "*" }
  ]
}
<details> <summary><strong>v1.0.0 (legacy)</strong></summary>
hcl
module "vnet" {
  source = "git::https://github.com/keerthanaavelu/terraform-azure-vnet-module.git?ref=v1.0.0"

  resource_group_name            = "rg-dev-vnet"
  vnet_name                      = "vnet-dev"
  address_space                  = ["10.0.0.0/16"]
  subnet_name                    = "subnet-dev"
  subnet_prefix                  = ["10.0.1.0/24"]
  nsg_name                       = "nsg-dev"
  nsg_rule_name                  = "allow-ssh"
  nsg_rule_priority              = 100
  nsg_rule_port                  = "22"
  nsg_rule_source_address_prefix = "*"
}
</details>
🔧 Inputs
Name	Type	Required
resource_group_name	string	✅
location	string	default: eastus
vnet_name	string	✅
address_space	list(string)	✅
subnet_name	string	✅
subnet_prefix	list(string)	✅
nsg_name	string	✅
nsg_rules (v1.1.0+)	list(object)	✅
📤 Outputs

vnet_id · subnet_id · nsg_id

🏗️ Architecture Notes
State isolation — each environment gets its own state file, same backend container
Secure auth — Azure AD-based backend auth, no storage keys in code
Version pinning — consumers reference ?ref=vX.Y.Z, never main

Consumer environments → terraform-envs
