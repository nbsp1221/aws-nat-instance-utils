#!/bin/bash

#====================================================================================================
#
# AWS NAT INSTANCE SETUP SCRIPT
#
# This script configures an EC2 instance as a NAT instance.
# Designed for Amazon Linux 2023 or Amazon Linux 2.
# See https://docs.aws.amazon.com/vpc/latest/userguide/work-with-nat-instances.html for more information.
#
#====================================================================================================

RED="\033[0;31m"
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
BLUE="\033[0;34m"
NC="\033[0m"

cecho() {
  echo -e "$2$1$NC"
}

# Check if script is run as root
if [ "$(id -u)" != "0" ]; then
  cecho "This script must be run as root!" $RED
  exit 1
fi

# Update system packages
cecho "Updating system packages..." $BLUE
yum update -y

# Install and enable iptables
cecho "Installing and enabling iptables..." $BLUE
yum install iptables-services -y
systemctl enable iptables
systemctl start iptables

# Enable IP forwarding
cecho "Enabling IP forwarding..." $BLUE
echo "net.ipv4.ip_forward=1" | tee /etc/sysctl.d/custom-ip-forwarding.conf
sysctl -p /etc/sysctl.d/custom-ip-forwarding.conf

# Identify the primary network interface
PRIMARY_NETWORK_INTERFACE=$(ip route | grep default | awk '{print $5}')
cecho "Primary network interface: $PRIMARY_NETWORK_INTERFACE" $YELLOW

# Configure NAT rules
cecho "Configuring NAT rules..." $BLUE
/sbin/iptables -t nat -A POSTROUTING -o $PRIMARY_NETWORK_INTERFACE -j MASQUERADE
/sbin/iptables -F FORWARD
service iptables save

# Complete
cecho "NAT instance setup complete!" $GREEN
cecho "Please ensure that you have disabled the 'Source/Destination Check' on this EC2 instance." $YELLOW
cecho "Also, update your VPC route tables to direct traffic through this NAT instance." $YELLOW
