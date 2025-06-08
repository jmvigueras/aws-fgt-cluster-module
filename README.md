# AWS FortiGate Cluster Module

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=for-the-badge)](LICENSE)

A Terraform module for deploying FortiGate clusters on AWS with support for both FGCP (FortiGate Clustering Protocol) and FGSP (FortiGate Session Sync Protocol) clustering modes.

> **⚠️ AI-Generated Content**: This repository contains AI-generated documentation and examples. Please review and test thoroughly before production use.

## Features

- 🏗️ **Multiple Cluster Types**: Support for FGCP and FGSP clustering
- 🌐 **Multi-AZ Deployment**: Deploy across multiple Availability Zones for high availability
- 🔧 **Flexible Configuration**: Customizable instance types, licensing, and network settings
- 🛡️ **Security Focused**: Built-in security groups and network segmentation
- 📊 **Gateway Load Balancer**: Optional GWLB integration for advanced traffic distribution
- 🏷️ **Consistent Tagging**: Standardized resource tagging for better management
- 🌟 **SD-WAN Ready**: Built-in support for SD-WAN Hub and Spoke configurations
- 🔗 **VPN Connectivity**: Automatic VPN tunnel configuration for SD-WAN deployments
- 📡 **BGP Support**: Dynamic routing with BGP for SD-WAN networks
- ⚡ **Auto-scaling**: Gateway Load Balancer integration for horizontal scaling
- 🔒 **Self-Contained**: Includes local FortiGate configuration module for reliability

## Architecture

This module creates a complete FortiGate cluster infrastructure including:

**Self-Contained Design**: This module includes a local `fgt_config` module that provides all FortiGate configuration templates and logic locally, ensuring reliable deployments without external dependencies.

- VPC with public and private subnets across multiple AZs
- FortiGate instances configured in FGCP or FGSP mode
- Security groups with appropriate rules
- Network interfaces and routing
- Optional Gateway Load Balancer configuration
- IAM roles and policies for FortiGate operations

## Usage

### Basic FGCP Cluster (Single AZ)

```hcl
module "fortigate_cluster" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  prefix = "my-fgt-cluster"
  region = "us-west-2"
  azs    = ["us-west-2a"]

  fgt_number_peer_az = 2
  fgt_cluster_type   = "fgcp"
  
  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2795"
  
  fgt_vpc_cidr = "10.10.0.0/24"
  
  public_subnet_names_extra  = ["bastion"]
  private_subnet_names_extra = ["tgw", "protected"]
}
```

### FGCP Cluster with High Availability (Multi-AZ)

```hcl
module "fortigate_cluster_ha" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  prefix = "my-fgt-ha"
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b"]

  fgt_number_peer_az = 1
  fgt_cluster_type   = "fgcp"
  
  license_type  = "payg"
  instance_type = "c6i.xlarge"
  fgt_build     = "build2795"
  
  fgt_vpc_cidr = "10.20.0.0/24"
}
```

### FGSP Cluster with Gateway Load Balancer

```hcl
module "fortigate_fgsp_gwlb" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  prefix = "my-fgt-fgsp"
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b", "us-west-2c"]

  fgt_number_peer_az = 1
  fgt_cluster_type   = "fgsp"
  
  license_type  = "byol"
  instance_type = "c6i.large"
  fgt_build     = "build2795"
  
  fgt_vpc_cidr = "10.30.0.0/23"
  config_gwlb  = true
}
```

### SD-WAN Hub Configuration

```hcl
module "fortigate_sdwan_hub" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  prefix = "sdwan-hub"
  region = "us-west-2"
  azs    = ["us-west-2a", "us-west-2b"]

  fgt_cluster_type = "fgcp"
  fgt_number_peer_az = 1
  
  license_type  = "byol"
  instance_type = "c6i.large"
  
  # Enable SD-WAN Hub functionality
  config_hub = true
  
  hub = [{
    id                = "AWS-HUB-WEST"
    bgp_asn_hub       = "65001"
    vpn_cidr          = "172.16.100.0/24"
    vpn_psk           = "your-secure-psk-key"
    cidr              = "10.0.0.0/8"
    vpn_port          = "public"
  }]
  
  fgt_vpc_cidr = "10.100.0.0/24"
}
```

### SD-WAN Spoke Configuration

```hcl
module "fortigate_sdwan_spoke" {
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.3"

  prefix = "sdwan-spoke-east"
  region = "us-east-1"
  azs    = ["us-east-1a"]

  fgt_cluster_type = "fgcp"
  fgt_number_peer_az = 1
  
  license_type  = "payg"
  instance_type = "c6i.large"
  
  # Enable SD-WAN Spoke functionality
  config_spoke = true
  
  spoke = {
    id      = "AWS-SPOKE-EAST"
    cidr    = "10.200.0.0/24"
    bgp_asn = "65002"
  }
  
  # Hub connection details
  hubs = [{
    id                = "AWS-HUB-WEST"
    bgp_asn           = "65001"
    external_ip       = "52.x.x.x"  # Hub public IP from hub output
    hub_ip            = "172.16.100.1"
    site_ip           = "172.16.100.10"
    hck_ip            = "172.16.100.1"
    vpn_psk           = "your-secure-psk-key"
    cidr              = "10.0.0.0/8"
    ike_version       = "2"
    network_id        = "1"
    dpd_retryinterval = "5"
    sdwan_port        = "public"
  }]
  
  fgt_vpc_cidr = "10.200.0.0/24"
}
```

## Cluster Types

### FGCP (FortiGate Clustering Protocol)
- **Members**: 2 FortiGates only
- **Deployment**: 1 or 2 Availability Zones
- **Use Case**: Active-Passive high availability
- **Sync**: Configuration and session synchronization

### FGSP (FortiGate Session Sync Protocol)
- **Members**: Up to 16 FortiGates (recommended: ≤8)
- **Deployment**: Multiple Availability Zones
- **Use Case**: Active-Active load balancing
- **Sync**: Session synchronization only

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| prefix | Prefix for resource names | `string` | n/a | yes |
| region | AWS region for deployment | `string` | n/a | yes |
| azs | List of Availability Zones | `list(string)` | n/a | yes |
| fgt_cluster_type | Type of FortiGate cluster (fgcp/fgsp) | `string` | `"fgcp"` | no |
| fgt_number_peer_az | Number of FortiGates per AZ | `number` | `1` | no |
| instance_type | EC2 instance type for FortiGates | `string` | `"c6i.large"` | no |
| license_type | License type (byol/payg) | `string` | `"byol"` | no |
| fgt_build | FortiGate firmware build | `string` | `"build2795"` | no |
| fgt_vpc_cidr | CIDR block for the VPC | `string` | n/a | yes |
| config_gwlb | Enable Gateway Load Balancer | `bool` | `false` | no |
| public_subnet_names_extra | Additional public subnet names | `list(string)` | `[]` | no |
| private_subnet_names_extra | Additional private subnet names | `list(string)` | `[]` | no |
| config_hub | Enable SD-WAN Hub configuration | `bool` | `false` | no |
| config_spoke | Enable SD-WAN Spoke configuration | `bool` | `false` | no |
| hub | SD-WAN Hub configuration parameters | `list(object)` | `[]` | no |
| spoke | SD-WAN Spoke configuration parameters | `object` | See example | no |
| hubs | List of Hub connection details for Spokes | `list(object)` | `[]` | no |
## Outputs

| Name | Description |
|------|-------------|
| fgt | Complete FortiGate information including management URLs, passwords, and public IPs |
| api_key | API key for FortiGate instances (sensitive) |
| keypair_name | Name of the SSH key pair |
| vpc_id | ID of the created VPC |
| subnet_public_ids | IDs of public subnets |
| subnet_private_ids | IDs of private subnets |
| subnet_cidrs | CIDR blocks of all subnets |
| rt_ids | Route table IDs |
| sg_ids | Security group IDs |

## Examples

See the [examples](./examples) directory for complete deployment scenarios:

- [FGCP Single AZ](./examples/fgcp-single-az) - Basic FGCP cluster in one AZ
- [FGCP Multi-AZ](./examples/fgcp-multi-az) - High availability FGCP across multiple AZs
- [FGSP with GWLB](./examples/fgsp-gwlb) - Scalable FGSP cluster with Gateway Load Balancer
