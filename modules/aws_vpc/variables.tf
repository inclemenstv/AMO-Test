variable "name" {
  description = "name"
  type        = string
  default     = ""
}

variable "environment" {
  description = "Environment"
  type        = string
  default     = ""
}

variable "cidr_network" {
  description = ""
  type        = string
  default     = "10.0.0.0/16"
}
