# AVZ

locals {
  availability_zones = data.aws_availability_zones.available.names
}

locals {
  cidr_main_subnets  = 1
  max_main_subnets   = length(data.aws_availability_zones.available.names)
}

locals {
  main_subnets = [
    for az in local.availability_zones :
    "10.0.${local.cidr_main_subnets + index (local.availability_zones, az) }.0/24"
    if index(local.availability_zones, az) < local.max_main_subnets
  ]
}
