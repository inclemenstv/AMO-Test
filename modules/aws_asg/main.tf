####################################################################
# AWS aws_launch_configuration                                    ##
####################################################################
resource aws_launch_configuration web_instance {
  name_prefix                 = "${var.name}-web-"
  image_id                    = var.image_id
  instance_type               = var.instance_type
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  user_data                   = file("${path.module}/files/init_webserver.sh.tpl")
  associate_public_ip_address = var.associate_public_ip_address
  security_groups             = var.security_groups

  root_block_device {
    volume_type           = var.volume_type
    volume_size           = var.volume_size
    iops                  = var.iops
    delete_on_termination = true
    encrypted             = true
  }
}

####################################################################
# AWS LoadBalancer                                                ##
####################################################################

resource aws_lb alb {
  name                       = var.name
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = var.security_groups
  enable_cross_zone_load_balancing = true
  subnets                    = var.subnet_ids
  enable_deletion_protection = false

  tags = {
    Environment = var.environment
  }
}


resource aws_lb_target_group app {
  name                 = var.name
  port                 = 80
  protocol             = "HTTP"
  target_type          = "instance"
  vpc_id               = var.vpc_id
  deregistration_delay = 100

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 15
    interval            = 30
    protocol            = "HTTP"
  }

  depends_on = [aws_lb.alb]

}

resource aws_lb_listener app {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  depends_on = [aws_lb.alb, aws_lb_target_group.app]
}

resource aws_lb_listener app_https {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate_validation.cert.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app.arn
  }

  depends_on = [aws_lb.alb, aws_lb_target_group.app]

}

####################################################################
# AWS certificate                                                 ##
####################################################################

resource aws_acm_certificate cert {
  domain_name       = var.domain_name
  validation_method = "DNS"

  tags = {
    Name        = var.name
    Environment = var.environment
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource aws_route53_record cert_validation {
  for_each = {
    for dvo in aws_acm_certificate.cert.domain_validation_options : dvo.domain_name => {
      name    = dvo.resource_record_name
      record  = dvo.resource_record_value
      type    = dvo.resource_record_type
      zone_id = data.aws_route53_zone.zone.id
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = each.value.zone_id
}

resource aws_acm_certificate_validation cert {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

resource "aws_route53_record" "alias_route53_record" {
  zone_id = data.aws_route53_zone.zone.id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}
####################################################################
# AWS aws_autoscaling_group                                       ##
####################################################################
resource "aws_autoscaling_group" "asg" {
  name                      = "${var.name}-${var.environment}-asg"
  vpc_zone_identifier       = var.subnet_ids
  launch_configuration      = aws_launch_configuration.web_instance.name
  target_group_arns         = [aws_lb_target_group.app.arn]
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_capacity
  min_size                  = var.min_capacity
  health_check_grace_period = 300
  health_check_type         = "EC2"
  termination_policies      = ["NewestInstance"]
  #  instance_refresh {
  #    strategy = "Rolling"
  #
  #  }
  tag {
    key                 = "Name"
    value               = "${var.name}-${var.environment}-webserver"
    propagate_at_launch = true
  }

  lifecycle {
    ignore_changes = [desired_capacity, target_group_arns]
  }
}



resource "aws_autoscaling_policy" "scale_down" {
  name                   = "${var.name}-${var.environment}_scale_down"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = -1
  cooldown               = 120
  depends_on = [aws_autoscaling_group.asg]
}

resource "aws_cloudwatch_metric_alarm" "scale_down" {
  alarm_description   = "Monitors CPU utilization for ${var.name}-${var.environment} ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_down.arn]
  alarm_name          = "${var.name}-${var.environment}_scale_down"
  comparison_operator = "LessThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "20"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}


resource "aws_autoscaling_policy" "scale_up" {
  name                   = "${var.name}-${var.environment}_scale_up"
  autoscaling_group_name = aws_autoscaling_group.asg.name
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
  cooldown               = 120
  depends_on = [aws_autoscaling_group.asg]
}

resource "aws_cloudwatch_metric_alarm" "scale_up" {
  alarm_description   = "Monitors CPU utilization for ${var.name}-${var.environment} ASG"
  alarm_actions       = [aws_autoscaling_policy.scale_up.arn]
  alarm_name          = "${var.name}-${var.environment}_scale_up"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"
  threshold           = "80"
  evaluation_periods  = "2"
  period              = "120"
  statistic           = "Average"

  dimensions = {
    AutoScalingGroupName = aws_autoscaling_group.asg.name
  }
}