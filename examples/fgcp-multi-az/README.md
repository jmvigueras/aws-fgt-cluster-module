# FGCP Multi-AZ Example

This example demonstrates how to deploy a FortiGate FGCP (FortiGate Clustering Protocol) cluster across multiple Availability Zones for maximum high availability.

## Architecture

- **Cluster Type**: FGCP (Active-Passive)
- **Members**: 2 FortiGate instances (1 per AZ)
- **Deployment**: 2 Availability Zones
- **High Availability**: Cross-AZ redundancy with automatic failover

## Features

- True high availability across multiple AZs
- FGCP clustering with automatic failover
- Cross-AZ network redundancy
- Shared configuration and session synchronization
- Protection against AZ-level failures

## Usage

1. **Clone or reference the module**:
   ```bash
   git clone https://github.com/jmvigueras/aws-fgt-cluster-module.git
   cd aws-fgt-cluster-module/examples/fgcp-multi-az
   ```

2. **Deploy the infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

3. **Verify cluster status**:
   - Access primary FortiGate management interface
   - Check cluster status: `get system ha status`
   - Verify synchronization between units

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region for deployment | string | us-west-2 |
| availability_zones | List of AZs (must be exactly 2) | list(string) | ["us-west-2a", "us-west-2b"] |
| prefix | Prefix for resource names | string | fgt-fgcp-ha |
| vpc_cidr | CIDR block for the VPC | string | 10.20.0.0/24 |
| license_type | License type (byol/payg) | string | payg |
| instance_type | EC2 instance type | string | c6i.xlarge |
| fgt_build | FortiGate firmware build | string | build2795 |

## High Availability Benefits

1. **AZ-Level Protection**: Survives complete AZ failure
2. **Automatic Failover**: Seamless failover without manual intervention
3. **Session Preservation**: Active sessions maintained during failover
4. **Configuration Sync**: Automatic configuration synchronization
5. **Network Redundancy**: Multiple network paths and gateways

## Failover Testing

To test failover capabilities:

1. **Simulate primary failure**:
   ```bash
   # Stop primary instance via AWS console
   aws ec2 stop-instances --instance-ids <primary-instance-id>
   ```

2. **Monitor failover**:
   - Check cluster status on secondary unit
   - Verify traffic continues flowing
   - Test connectivity to protected resources

3. **Restore service**:
   ```bash
   # Start primary instance
   aws ec2 start-instances --instance-ids <primary-instance-id>
   ```

## Cost Considerations

- 2 x FortiGate instances (c6i.xlarge by default)
- Cross-AZ data transfer charges
- Multiple NAT Gateways (one per AZ)
- Elastic IP addresses
- Higher instance type for production workloads

Estimated monthly cost: ~$400-800 depending on instance type and data transfer.

## Cleanup

```bash
terraform destroy
```

**Note**: Ensure all resources are properly terminated to avoid ongoing charges.

## Troubleshooting

Common issues and solutions:

1. **Cluster not forming**: Check security groups allow HA sync traffic
2. **Failover not working**: Verify heartbeat interfaces are configured
3. **Configuration not syncing**: Check network connectivity between units
4. **Performance issues**: Consider larger instance types for production
