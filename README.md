# terraform-aws

## versions

terraform - `v1.2.1`
aws provider - `~> 3.58.0`

## Descriptions

THis is terraform script connected to [terrafom cloud](https://app.terraform.io/app/Photowhy/workspaces/terraform-aws)

This script created:

* VPC (new private network)

* Create application load balancer and certificate

* Create Autoscaling group


## [Terraform variables](https://app.terraform.io/app/Photowhy/workspaces/terraform-aws/variables)

| Name           | type   | Desription                |
|----------------| ------ |---------------------------|
| aws_access_key | string | AWS access key id         |
| aws_secret_key | string | AWS secret access key     |
| aws_region     | string | AWS default region        |
| project_name   | string | The project name          |
| environment    | string | The environment           |
| cidr_network   | string | The cidr block            |
| instance_type  | string | The type instance for ASG |
| image_id       | string | The ID ami                |
| domain_name    | string | Domain name               |
| domain         | string | Hosted zone name          |
| key_name       | string | SSH Key-pair name         |


## How to use:

* сopy terraform.tfvars.example to terraform.tfvars add your values
* run terraform plan
* terraform apply
* Check outputs - alb_dns name

