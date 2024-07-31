# AWS NAT Instance Utils

This repository provides utilities for setting up and managing NAT(Network Address Translation) instances on Amazon EC2. The tools are designed for use with Amazon Linux 2023 or Amazon Linux 2.

## Prerequisites

- An EC2 instance running Amazon Linux 2023 or Amazon Linux 2.
- The instance should be launched in a public subnet of your VPC.

## Usage

You can run this script directly in your EC2 instance using curl:

```bash
curl -sSL https://raw.githubusercontent.com/nbsp1221/aws-nat-instance-utils/main/setup.sh | sudo bash
```

## Post-Setup Steps

After running the script:

1. Ensure 'Source/Destination Check' is disabled on the EC2 instance.
2. Update your VPC route tables to direct traffic through this NAT instance.

## References

- https://docs.aws.amazon.com/vpc/latest/userguide/vpc-nat-comparison.html
