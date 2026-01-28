#!/bin/bash
set -e

echo "🧪 Testing Ansible Connection"

# Generate inventory
./generate_inventory.sh

# Test ping
ansible all -m ping

# Test command
ansible all -m command -a "whoami"

# Test sudo
ansible all -m command -a "whoami" --become

# Show system info
ansible all -m setup -a "filter=ansible_distribution*"

echo "✅ Connection test passed!"
