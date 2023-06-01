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

  # Runtime variables
  is_onprem = true
  allow_all = false

  # Set dyanmic rules based on runtime variables
  onprem_ingress_rules = local.is_onprem == true ? ["on-prem"] : []
  all_ingress_rules    = local.allow_all == true ? ["all-all"] : []

  # Create meged rule list
  updated_ingress_rules = setunion(local.sg_groups.web.ingress_rules, local.onprem_ingress_rules, local.all_ingress_rules)

}


