output "default_security_group_id" {
  value = module.vpc.default_security_group_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

output "igw_id" { 
  value = module.vpc.igw_id
}

output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block
}