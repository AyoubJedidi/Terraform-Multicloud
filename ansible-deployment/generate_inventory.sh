#!/bin/bash
# Generate inventory based on scenario

INVENTORY_DIR="inventory"
mkdir -p $INVENTORY_DIR

if [ -f "terraform_outputs.json" ]; then
    echo "📋 Scenario: VM created by Terraform"
    
    # Parse Terraform outputs
    VM_IP=$(jq -r '.vm_ip.value' terraform_outputs.json)
    VM_USER=$(jq -r '.vm_user.value // "azureuser"' terraform_outputs.json)
    SSH_KEY_PATH="ssh_keys/terraform_key.pem"
    
    # Save SSH key from Terraform
    mkdir -p ssh_keys
    jq -r '.vm_private_key.value' terraform_outputs.json > $SSH_KEY_PATH
    chmod 600 $SSH_KEY_PATH
    
elif [ -f "existing_vm.env" ]; then
    echo "📋 Scenario: Using existing VM"
    
    # Load from environment file
    source existing_vm.env
    SSH_KEY_PATH=$EXISTING_VM_SSH_KEY
    
else
    echo "❌ Error: No VM information found!"
    echo "Create either:"
    echo "  - terraform_outputs.json (from Terraform)"
    echo "  - existing_vm.env (for existing VM)"
    exit 1
fi

# Generate inventory
cat > $INVENTORY_DIR/hosts.ini << INV
[target_vms]
target-vm ansible_host=$VM_IP ansible_user=$VM_USER ansible_ssh_private_key_file=../$SSH_KEY_PATH

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INV

echo "✅ Inventory generated:"
cat $INVENTORY_DIR/hosts.ini
