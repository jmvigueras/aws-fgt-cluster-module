# AWS FortiGate Cluster Module

[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![License](https://img.shields.io/badge/license-Apache%202.0-blue.svg?style=for-the-badge)](LICENSE)

A Terraform module for deploying FortiGate clusters on AWS with support for both FGCP (FortiGate Clustering Protocol) and FGSP (FortiGate Session Sync Protocol) clustering modes.

## Features

- 🏗️ **Multiple Cluster Types**: Support for FGCP and FGSP clustering
- 🌐 **Multi-AZ Deployment**: Deploy across multiple Availability Zones for high availability
- 🔧 **Flexible Configuration**: Customizable instance types, licensing, and network settings
- 🛡️ **Security Focused**: Built-in security groups and network segmentation
- 📊 **Gateway Load Balancer**: Optional GWLB integration for advanced traffic distribution
- 🏷️ **Consistent Tagging**: Standardized resource tagging for better management

## Architecture

This module creates a complete FortiGate cluster infrastructure including:

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
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.0"

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
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.0"

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
  source = "github.com/jmvigueras/aws-fgt-cluster-module?ref=v1.0.0"

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

## Outputs

| Name | Description |
|------|-------------|
| fgt_public_ips | Public IP addresses of FortiGate instances |
| fgt_private_ips | Private IP addresses of FortiGate instances |
| fgt_mgmt_urls | Management URLs for FortiGate instances |
| vpc_id | ID of the created VPC |
| public_subnet_ids | IDs of public subnets |
| private_subnet_ids | IDs of private subnets |
| security_group_ids | IDs of created security groups |

## Examples

See the [examples](./examples) directory for complete deployment scenarios:

- [FGCP Single AZ](./examples/fgcp-single-az)
- [FGCP Multi-AZ](./examples/fgcp-multi-az)
- [FGSP with GWLB](./examples/fgsp-gwlb)
- [Complete Infrastructure](./examples/complete)

## Security Considerations

- **Network Segmentation**: Separate public and private subnets
- **Security Groups**: Restrictive ingress/egress rules
- **IAM Roles**: Least privilege access for FortiGate operations
- **Encryption**: EBS volumes encrypted by default
- **Access Control**: Management access through secure channels only

## Cost Optimization

- Choose appropriate instance types based on throughput requirements
- Consider PAYG vs BYOL licensing based on usage patterns
- Use Spot instances for non-production environments
- Implement proper tagging for cost allocation

## Support

This is a community module maintained by [jmvigueras](https://github.com/jmvigueras). 

### Reporting Issues
Please report issues, bugs, and feature requests via [GitHub Issues](https://github.com/jmvigueras/aws-fgt-cluster-module/issues).

### Contributing
Contributions are welcome! Please read our [Contributing Guidelines](CONTRIBUTING.md) before submitting pull requests.

## License

This module is licensed under the Apache License 2.0. See [LICENSE](LICENSE) file for details.

## Disclaimer

This module is provided as-is for educational and testing purposes. Users are responsible for:
- Understanding AWS costs associated with deployed resources
- Ensuring compliance with security requirements
- Testing thoroughly before production deployment
- Maintaining and updating the infrastructure appropriately

**⚠️ Important**: AWS resources created by this module will incur costs. Please review AWS pricing and clean up resources when no longer needed.

---

## Acknowledgments

- [Fortinet](https://www.fortinet.com/) for FortiGate documentation and best practices
- [AWS](https://aws.amazon.com/) for cloud infrastructure and services
- Terraform community for modules and best practices
