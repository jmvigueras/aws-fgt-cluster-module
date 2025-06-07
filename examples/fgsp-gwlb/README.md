# FGSP with Gateway Load Balancer Example

This example demonstrates how to deploy a FortiGate FGSP (FortiGate Session Sync Protocol) cluster with AWS Gateway Load Balancer for high-performance, scalable traffic inspection.

## Architecture

- **Cluster Type**: FGSP (Active-Active)
- **Members**: 3 FortiGate instances (1 per AZ by default)
- **Deployment**: 3 Availability Zones
- **Load Balancing**: AWS Gateway Load Balancer
- **Scaling**: Horizontal scaling with session synchronization

## Features

- FGSP clustering for active-active operation
- AWS Gateway Load Balancer integration
- Session synchronization across cluster members
- Horizontal scaling capabilities
- High throughput traffic inspection
- Bump-in-the-wire transparent inspection

## Gateway Load Balancer Benefits

1. **Transparent Inspection**: Bump-in-the-wire deployment
2. **High Performance**: Optimized for high-throughput traffic
3. **Horizontal Scaling**: Add/remove FortiGates as needed
4. **Session Affinity**: Maintains session stickiness
5. **Health Monitoring**: Automatic health checks and traffic redistribution

## Usage

1. **Clone or reference the module**:
   ```bash
   git clone https://github.com/jmvigueras/aws-fgt-cluster-module.git
   cd aws-fgt-cluster-module/examples/fgsp-gwlb
   ```

2. **Customize deployment** (optional):
   ```hcl
   # terraform.tfvars
   availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c"]
   fgt_per_az        = 2  # Scale to 2 FortiGates per AZ
   instance_type     = "c6i.xlarge"  # Larger instances for higher throughput
   ```

3. **Deploy the infrastructure**:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. **Configure FGSP clustering**:
   - Access each FortiGate management interface
   - Configure FGSP cluster settings
   - Verify session synchronization

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| region | AWS region for deployment | string | us-west-2 |
| availability_zones | List of AZs (2-4 supported) | list(string) | ["us-west-2a", "us-west-2b", "us-west-2c"] |
| fgt_per_az | FortiGates per AZ (1-4) | number | 1 |
| prefix | Prefix for resource names | string | fgt-fgsp-gwlb |
| vpc_cidr | CIDR block for VPC | string | 10.30.0.0/23 |
| license_type | License type (byol/payg) | string | byol |
| instance_type | EC2 instance type | string | c6i.large |
| fgt_build | FortiGate firmware build | string | build2795 |

## Scaling Options

### Scale Out (Add More FortiGates)

```hcl
# Increase FortiGates per AZ
fgt_per_az = 2

# Or add more Availability Zones
availability_zones = ["us-west-2a", "us-west-2b", "us-west-2c", "us-west-2d"]
```

### Scale Up (Larger Instances)

```hcl
# For higher throughput
instance_type = "c6i.xlarge"   # Up to 10 Gbps
instance_type = "c6i.2xlarge"  # Up to 25 Gbps
instance_type = "c6i.4xlarge"  # Up to 50 Gbps
```

## Integration with Workload VPCs

To integrate with existing workload VPCs:

```hcl
# Create VPC endpoint in workload VPC
resource "aws_vpc_endpoint" "gwlb_endpoint" {
  vpc_id              = var.workload_vpc_id
  service_name        = module.fortigate_fgsp_gwlb.gwlb_service_name
  route_table_ids     = [var.workload_route_table_id]
  
  tags = {
    Name = "gwlb-endpoint-workload"
  }
}

# Update route tables to redirect traffic through GWLB endpoint
resource "aws_route" "inspection_route" {
  route_table_id         = var.workload_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = aws_vpc_endpoint.gwlb_endpoint.id
}
```

## Monitoring and Observability

Monitor cluster performance:

```bash
# Check cluster status on each FortiGate
get system ha status

# Monitor session sync
get system session-sync

# Check GWLB target health
aws elbv2 describe-target-health --target-group-arn <target-group-arn>

# View FortiGate logs
tail -f /var/log/log/traffic
```

## Performance Considerations

| Instance Type | Network Performance | Recommended Use Case |
|---------------|-------------------|---------------------|
| c6i.large | Up to 12.5 Gbps | Development/Testing |
| c6i.xlarge | Up to 12.5 Gbps | Small Production |
| c6i.2xlarge | Up to 25 Gbps | Medium Production |
| c6i.4xlarge | Up to 50 Gbps | Large Production |

## Cost Considerations

- FortiGate instances: 3 x c6i.large (default)
- Gateway Load Balancer: ~$22/month + data processing
- Data transfer between AZs
- Higher costs for larger instance types

Estimated monthly cost: ~$600-1500 depending on scale and data processing.

## Troubleshooting

Common issues and solutions:

1. **GWLB health checks failing**:
   - Verify FortiGate interfaces are up
   - Check security group rules for health check traffic
   - Ensure FortiGate is responding to health checks

2. **Session sync not working**:
   - Verify FGSP configuration on all cluster members
   - Check network connectivity between FortiGates
   - Confirm sync interfaces are properly configured

3. **Traffic not being inspected**:
   - Verify VPC endpoint configuration
   - Check route table entries
   - Confirm GWLB target group health

4. **Performance issues**:
   - Monitor CPU and memory usage on FortiGates
   - Consider scaling up instance types
   - Add more cluster members for horizontal scaling

## Cleanup

```bash
terraform destroy
```

**Note**: Ensure all VPC endpoints in workload VPCs are removed before destroying the infrastructure.
