variable project_name {
  description = "The project name"
  type        = string
  default     = "AMO-test"
}

variable environment {
  description = "The environment"
  type        = string
  default     = ""
}

variable aws_region {
  description = "AWS region"
  type        = string
  default     = ""
}

variable aws_access_key {
  description = "AWS access key"
  type        = string
  default     = ""
}

variable aws_secret_key {
  description = "AWS secret"
  type        = string
  default     = ""
}

variable "cidr_network" {
  description = "The cidr block"
  type        = string
  default     = "10.0.0.0/16"
}
variable instance_type {
  description = "The type instance"
  type        = string
  default     = ""
}
variable image_id {
  description = "The ID ami"
  type        = string
  default     = "ami-0233214e13e500f77"
}
variable "desired_capacity" {
  description = "instance count asg"
  default = 3
}