variable name {
  description = "The name security group"
  type        = string
  default     = ""
}

variable vpc_id {
  description = "The ID VPC"
  type        = string
}

variable webserver_ports {
  description = "The list of ports for webserver"
  type        = list(string)
  default     = ["80", "443", "22"]
}


variable alb_ports {
  description = "The list of ports for alb"
  type        = list(string)
  default     = ["80", "443"]
}