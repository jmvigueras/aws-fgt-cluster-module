terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = var.region
}

# Deploy FortiGate FGCP cluster across multiple AZs for high availability
module "fortigate_cluster_ha" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.0"

  prefix = var.prefix
  region = var.region
  azs    = var.availability_zones

  fgt_number_peer_az = 1  # 1 FortiGate per AZ for FGCP
  fgt_cluster_type   = "fgcp"
  
  license_type  = var.license_type
  instance_type = var.instance_type
  fgt_build     = var.fgt_build
  
  fgt_vpc_cidr = var.vpc_cidr
  
  public_subnet_names_extra  = ["bastion"]
  private_subnet_names_extra = ["tgw", "protected"]
}
