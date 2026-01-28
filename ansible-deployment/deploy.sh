#!/bin/bash
set -e

PLAYBOOK="${1:-playbooks/deploy-full.yml}"

echo "🚀 Starting Deployment"
echo "Playbook: $PLAYBOOK"

# Generate inventory
./generate_inventory.sh

# Run playbook
ansible-playbook $PLAYBOOK -v

echo "✅ Deployment complete!"
