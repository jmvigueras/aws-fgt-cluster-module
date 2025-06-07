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

# Deploy FortiGate FGSP cluster with Gateway Load Balancer
module "fortigate_fgsp_gwlb" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.0"

  prefix = var.prefix
  region = var.region
  azs    = var.availability_zones

  fgt_number_peer_az = var.fgt_per_az
  fgt_cluster_type   = "fgsp"
  
  license_type  = var.license_type
  instance_type = var.instance_type
  fgt_build     = var.fgt_build
  
  fgt_vpc_cidr = var.vpc_cidr
  config_gwlb  = true  # Enable Gateway Load Balancer
}
