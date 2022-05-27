 module vpc {
   source        = "./modules/aws_vpc"
   name          = "${var.project_name}-${var.environment}"
   environment   = var.environment
   cidr_network  = var.cidr_network
 }

module "sg" {
  source = "./modules/aws_sg"
  name   = "${var.project_name}-${var.environment}"
  vpc_id = module.vpc.vpc_id
}

 module "asg" {
   source           = "./modules/aws_asg"
   name             = "${var.project_name}-${var.environment}"
   desired_capacity = var.desired_capacity
   min_capacity     = 3
   max_capacity     = 6
   image_id         = var.image_id
   security_groups  = [module.sg.webserver_sg_id, module.sg.alb_sg_id]
   instance_type    = var.instance_type
   vpc_id           = module.vpc.vpc_id
   subnet_ids       = module.vpc.subnet_id
   key_name         = "AMO-SSH-Key"
   domain_name      = "task1.fun"
   domain           = "task1.fun"
 }