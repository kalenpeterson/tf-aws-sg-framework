# Create WEB Rules for this APP with Module 
module "aws_sg_web" {
  source = "../modules/aws_sg_web"

  vpc_id            = ""
  ingress_cidr_ipv4 = "10.0.0.0/8"
  egress_cidr_ipv4  = "10.0.0.0/8"
}
