terraform {
  required_version = ">= 0.13.1"
}

module "sg-rules" {
    source = "../modules/sg-rules"
}

