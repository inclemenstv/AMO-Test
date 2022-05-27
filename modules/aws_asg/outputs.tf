output launch_id {
  description = ""
  value       = aws_launch_configuration.web_instance.id
}

output "alb_dns" {
  value = aws_lb.alb.dns_name
}