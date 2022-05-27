output webserver_sg_id {
  description = "ID created security group"
  value       = aws_security_group.webserver.id
}

output webserver_sg_name {
  description = "Name created security group"
  value       = aws_security_group.webserver.name
}

output alb_sg_id {
  description = "ID created security group"
  value       = aws_security_group.alb.id
}

output alb_sg_name {
  description = "Name created security group"
  value       = aws_security_group.alb.name
}