terraform {
  required_version = ">= 0.13.1"
}

module "sg-rules" {
    source = "../modules/sg-rules"
}

# Set Local vars
locals {
  create = true

  # Assign the rule definitions to local vars for readability
  sg_settings = module.sg-rules.settings
  sg_zones    = module.sg-rules.zones
  sg_rules    = module.sg-rules.rules
  sg_groups   = module.sg-rules.groups
}


