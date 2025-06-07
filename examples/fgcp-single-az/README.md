# FGCP Single AZ Example

This example demonstrates how to deploy a FortiGate FGCP (FortiGate Clustering Protocol) cluster in a single Availability Zone using the aws-fgt-cluster-module.

## Architecture

- **Cluster Type**: FGCP (Active-Passive)
- **Members**: 2 FortiGate instances
- **Deployment**: Single Availability Zone
- **High Availability**: Active-Passive within the AZ

## Features

- FGCP clustering with automatic failover
- Public and private subnets
- Additional subnets for bastion, TGW, and protected workloads
- Security groups configured for FortiGate operations
- Network interfaces properly configured for clustering

## Usage

1. **Clone or reference the module**:
   ```bash
   git clone https://github.com/jmvigueras/aws-fgt-cluster-module.git
   cd aws-fgt-cluster-module/examples/fgcp-single-az
   ```

2. **Deploy the infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Access FortiGate management**:
   ```bash
   # Get FortiGate information
   terraform output fgt
   
   # Access management URL (use the fgt_mgmt URL from output)
   # Default credentials: admin / [instance-id from fgt_pass]
   ```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region for deployment | string | us-west-2 |
| availability_zone | Availability Zone for deployment | string | us-west-2a |
| prefix | Prefix for resource names | string | fgt-fgcp-1az |
| vpc_cidr | CIDR block for the VPC | string | 10.10.0.0/24 |
| license_type | License type (byol/payg) | string | byol |
| instance_type | EC2 instance type | string | c6i.large |
| fgt_build | FortiGate firmware build | string | build2795 |

## Outputs

The main output `fgt` contains all FortiGate information:

```bash
terraform output fgt
{
  "fgt-1" = {
    "fgt_mgmt" = "https://52.12.34.56:8443"
    "fgt_pass" = "i-0123456789abcdef0" 
    "fgt_public" = "52.12.34.56"
  }
  "fgt-2" = {
    "fgt_mgmt" = "https://52.98.76.54:8443"
    "fgt_pass" = "i-0fedcba987654321f"
    "fgt_public" = "52.98.76.54"
  }
}
```

## Cost Considerations

- 2 x FortiGate instances (c6i.large by default)
- NAT Gateway for private subnet internet access
- Elastic IP addresses for public connectivity
- Data transfer costs

Estimated monthly cost: ~$200-400 depending on instance type and data transfer.

## Cleanup

```bash
terraform destroy
```

**Note**: Ensure all resources are properly terminated to avoid ongoing charges.
