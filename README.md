# Terraform Module - VMware Tags

This module manages VMware tag categories and tags.

## Variables

* `categories` - (Required) A list of tag categories to create. Each element must have the following attributes:
  * `name` - (Required) The name of the tag category.
  * `description` - (Optional) The description of the tag category.
  * `associable_types` - (Optional) A list of types of objects that can be tagged with tags in this category. [Associable Object Types](https://registry.terraform.io/providers/hashicorp/vsphere/latest/docs/resources/tag_category#associable-object-types)
  * cardinality - (Optional) The cardinality of the tag category (SINGLE or MULTIPLE).
* `tags` - (Optional) A list of tags to create. Each element must have the following attributes:
  * `category` - (Required) The category to which this tag belongs.
  * `name` - (Required) The name of the tag.
  * `description` - (Optional) The description of the tag.

## Outputs

* `categories` - A map of category IDs created by this module.
* `tags` - A map of tag IDs created by this module.

## Usage with Module

Define your module in `tags.tf`:

```hcl
module "vsphere_tags" {
  source = "git::https://github.com/svergun/terraform-module-vmware-tags.git"

  categories = {
    HomeLab = {
      description      = "Tags for HomeLab"
      cardinality      = "MULTIPLE"
      associable_types = ["VirtualMachine"]
    }
  }

  tags = {
    linux = {
      name        = "linux"
      category    = "HomeLab"
      description = "Linux OS tag"
    }
    ansible_managed = {
      name        = "ansible_managed"
      category    = "HomeLab"
      description = "Ansible managed tag"
    }
  }
}
```

Define the module output in `outputs.tf`:

```hcl
# Output vsphere category IDs
output "category_ids" {
  description = "IDs of created categories"
  value       = module.vsphere_tags.category_ids
}

# # Output vsphere tag IDs
output "tag_ids" {
  description = "IDs of created tags"
  value       = module.vsphere_tags.tag_ids
}
```

Define variables in `variables.tf`:

```hcl
variable "vcenter_url" {
  type        = string
  description = "The vCenter server to connect to"
}

variable "vcenter_user" {
  type        = string
  description = "The username for the vCenter user"
}

variable "vcenter_password" {
  type        = string
  description = "The password for the vCenter user"
}

variable "vcenter_unverified_ssl" {
  type        = bool
  description = "Whether or not to skip SSL verification"
  default     = false
}
```

Define the provider in `provider.tf`:

```hcl
# Configure the VMware vSphere provider
provider "vsphere" {
  vsphere_server       = var.vcenter_url
  user                 = var.vcenter_user
  password             = var.vcenter_password
  allow_unverified_ssl = var.vcenter_unverified_ssl
}

provider "aws" {
  profile = "my-aws-terraform"
  region  = "us-east-1"
}

terraform {
  backend "s3" {
    bucket  = "my-terraform-state"
    key     = "terraform/vmware/vcenter/terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
    profile = "my-aws-terraform"
  }
}
```

Define requirements in `terraform.tf`:

```hcl
terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.10.0"
    }
  }
}
```

Set your sensitive data in `.vault,auto,tfvars` (this is not best practice, use HashiCorp Vault or alternative secrets management for a production environment, approach in this example is for simplicity only and good for testing or home lab):

```hcl
vcenter_url   = "vcenter.lab.local"
vcenter_user     = "administrator@lab.local"
vcenter_password = "password"
```
