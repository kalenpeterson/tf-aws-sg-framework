# Import SG Rule definitions
module "sg-rules" {
  source = "../sg-rules"
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

# Retrive VPC
data "aws_vpc" "this" {
  id = var.vpc_id
}

# Create Test SG
resource "aws_security_group" "sg-web-test" {
  description = "SG Rule Mapping Testing (can delete)"
  vpc_id      = data.aws_vpc.this.id
}

# Create Ingress Prefix List
resource "aws_ec2_managed_prefix_list" "aws-web-ingress" {
  name           = "aws-web-ingress CIDR-s"
  address_family = "IPv4"
  max_entries    = local.sg_settings.prefix_list_max_entries

  # CIDR Block list generated by by sg-zones
  dynamic "entry" {
    for_each = local.sg_groups.web.ingress_zones
    content {
      cidr        = local.sg_zones[entry.value][0]
      description = local.sg_zones[entry.value][1]
    }
  }
}

# Create Egress Prefix List
resource "aws_ec2_managed_prefix_list" "aws-web-egress" {
  name           = "aws-web-egress CIDR-s"
  address_family = "IPv4"
  max_entries    = local.sg_settings.prefix_list_max_entries

  # CIDR Block list generated by by sg-zones
  dynamic "entry" {
    for_each = local.sg_groups.web.egress_zones
    content {
      cidr        = local.sg_zones[entry.value][0]
      description = local.sg_zones[entry.value][1]
    }
  }
}

# Create Ingress Rules for Web
resource "aws_vpc_security_group_ingress_rule" "aws-web" {
  count = local.create ? length(local.sg_groups.web.ingress_rules) : 0

  # Provided by Input
  security_group_id = aws_security_group.sg-web-test.id
  
  # Generated by sg-zones
  prefix_list_id = aws_ec2_managed_prefix_list.aws-web-ingress.id
  
  # Generated by sg-rules
  from_port      = local.sg_rules[local.sg_groups.web.ingress_rules[count.index]][0]
  to_port        = local.sg_rules[local.sg_groups.web.ingress_rules[count.index]][1]
  ip_protocol    = local.sg_rules[local.sg_groups.web.ingress_rules[count.index]][2]
  description    = local.sg_rules[local.sg_groups.web.ingress_rules[count.index]][3]
}

# Create Egress Rules for Web
resource "aws_vpc_security_group_egress_rule" "aws-web" {
  count = local.create ? length(local.sg_groups.web.egress_rules) : 0

  # Provided by Input
  security_group_id = aws_security_group.sg-web-test.id
  
  # Generated by sg-zones
  prefix_list_id = aws_ec2_managed_prefix_list.aws-web-egress.id
  
  # Generated by sg-rules
  from_port      = local.sg_rules[local.sg_groups.web.egress_rules[count.index]][0]
  to_port        = local.sg_rules[local.sg_groups.web.egress_rules[count.index]][1]
  ip_protocol    = local.sg_rules[local.sg_groups.web.egress_rules[count.index]][2]
  description    = local.sg_rules[local.sg_groups.web.egress_rules[count.index]][3]
}