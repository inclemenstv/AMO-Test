variable name {
  description = "The name"
  type        = string
  default     = ""
}
variable environment {
  description = "The environment"
  type        = string
  default     = "dev"
}

variable key_name {
  description = "The name key pair"
  type        = string
  default     = ""
}

variable instance_type {
  description = "The type instance"
  type        = string
  default     = ""
}

variable associate_public_ip_address {
  description = "Associating a public IP address with an instance in a VPC"
  type        = string
  default     = "false"
}


variable security_groups {
  description = "The ID list security groups"
  type        = list(string)
  default     = []
}

variable iam_instance_profile {
  description = "The name instance profile from IAM"
  type        = string
  default     = ""
}

variable image_id {
  description = "The ID ami"
  type        = string
  default     = ""
}

variable volume_type {
  description = "The type of EBS volume. Can be standard, gp2, gp3, io1, io2, sc1 or st1"
  type        = string
  default     = "io1"
}

variable volume_size {
  description = "The size of the drive in GiBs"
  type        = string
  default     = "10"
}

variable iops {
  description = "The amount of IOPS to provision for the disk. Only valid for type of io1, io2 or gp3."
  type        = string
  default     = "400"
}


variable subnet_ids {
  description = "IDs subnets"
  type        = list(string)
  default     = []
}

variable vpc_id {
  description = "ID vpc private"
  type        = string
  default     = ""
}

variable domain_name {
  description = "Sub domain name"
  type        = string
  default     = ""
}

variable domain {
  description = "The domain"
  type        = string
  default     = ""
}

variable "desired_capacity" {
  description = ""
}

variable "min_capacity" {
  description = ""
  default     = 2
}
variable "max_capacity" {
  description = ""
  default     = 4
}