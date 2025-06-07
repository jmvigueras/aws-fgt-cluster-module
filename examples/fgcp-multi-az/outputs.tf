output "fgt" {
  description = "FortiGate instance information including management URLs and passwords"
  value       = module.fortigate_cluster_ha.fgt
}

output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.fortigate_cluster_ha.vpc_id
}

output "subnet_public_ids" {
  description = "IDs of public subnets"
  value       = module.fortigate_cluster_ha.subnet_public_ids
}

output "subnet_private_ids" {
  description = "IDs of private subnets"
  value       = module.fortigate_cluster_ha.subnet_private_ids
}

output "api_key" {
  description = "API key for FortiGate instances"
  value       = module.fortigate_cluster_ha.api_key
  sensitive   = true
}

output "keypair_name" {
  description = "Name of the SSH key pair"
  value       = module.fortigate_cluster_ha.keypair_name
}
