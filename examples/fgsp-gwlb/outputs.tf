output "fgt" {
  description = "FortiGate instance information including management URLs and passwords"
  value       = module.fortigate_fgsp_gwlb.fgt
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.fortigate_fgsp_gwlb.vpc_id
}

output "subnet_public_ids" {
  description = "IDs of public subnets"
  value       = module.fortigate_fgsp_gwlb.subnet_public_ids
}

output "subnet_private_ids" {
  description = "IDs of private subnets"
  value       = module.fortigate_fgsp_gwlb.subnet_private_ids
}

output "api_key" {
  description = "API key for FortiGate instances"
  value       = module.fortigate_fgsp_gwlb.api_key
  sensitive   = true
}

output "keypair_name" {
  description = "Name of the SSH key pair"
  value       = module.fortigate_fgsp_gwlb.keypair_name
}

output "cluster_member_count" {
  description = "Total number of FortiGate cluster members"
  value       = length(var.availability_zones) * var.fgt_per_az
}
