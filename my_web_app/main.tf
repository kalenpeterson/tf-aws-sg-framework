# Create WEB Rules for this APP with Module 
module "aws_sg_web" {
  source = "../modules/aws_sg_web"
  vpc_id = ""
}
