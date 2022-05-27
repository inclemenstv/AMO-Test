output vpc_id {
  description = "ID private VPC"
  value       = aws_vpc.main.id
}

output subnet_id {
  description = "ID list subnets"
  value       = aws_subnet.main.*.id
}

output subnet_arn {
  description = "ARN list subnets"
  value       = aws_subnet.main.*.arn
}

output owner_id {
  description = "ID owner list subnets"
  value       = aws_subnet.main.*.owner_id
}

output subnet_cidr_block {
  description = "List subnets cidr block"
  value       = aws_subnet.main.*.cidr_block
}

