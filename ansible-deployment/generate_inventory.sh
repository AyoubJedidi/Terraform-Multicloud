#!/bin/bash
# Generate inventory based on scenario

INVENTORY_DIR="inventory"
mkdir -p $INVENTORY_DIR

if [ -f "terraform_outputs.json" ]; then
    echo "📋 Scenario: VM created by Terraform"
    
    # Parse Terraform outputs
    VM_IP=$(jq -r '.vm_ip.value' terraform_outputs.json)
    VM_USER=$(jq -r '.vm_user.value // "azureuser"' terraform_outputs.json)
    SSH_KEY_PATH="ssh_keys/azure_vm.pem"  # FIXED: Changed from terraform_key.pem
    
    # Save SSH key from Terraform (if not already saved)
    mkdir -p ssh_keys
    if [ ! -f "$SSH_KEY_PATH" ]; then
        jq -r '.vm_private_key.value' terraform_outputs.json > $SSH_KEY_PATH
        chmod 600 $SSH_KEY_PATH
    fi
    
    # Get absolute path
    SSH_KEY_ABS=$(readlink -f $SSH_KEY_PATH)
    
    # Generate inventory for remote VM
    cat > $INVENTORY_DIR/hosts.ini << INV
[target_vms]
target-vm ansible_host=$VM_IP ansible_user=$VM_USER ansible_ssh_private_key_file=$SSH_KEY_ABS ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INV
    
elif [ -f "existing_vm.env" ]; then
    echo "📋 Scenario: Using existing VM"
    
    # Load from environment file
    source existing_vm.env
    
    # Expand ~ to absolute path
    SSH_KEY_PATH=$(eval echo $EXISTING_VM_SSH_KEY)
    
    # Check if localhost
    if [ "$VM_IP" == "localhost" ] || [ "$VM_IP" == "127.0.0.1" ]; then
        echo "   Using local connection (no SSH)"
        
        # Generate inventory for localhost
        cat > $INVENTORY_DIR/hosts.ini << INV
[target_vms]
target-vm ansible_connection=local

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INV
    else
        echo "   Using SSH connection"
        
        # Generate inventory for remote VM with absolute path
        cat > $INVENTORY_DIR/hosts.ini << INV
[target_vms]
target-vm ansible_host=$VM_IP ansible_user=$VM_USER ansible_ssh_private_key_file=$SSH_KEY_PATH ansible_ssh_common_args='-o StrictHostKeyChecking=no'

[all:vars]
ansible_python_interpreter=/usr/bin/python3
INV
    fi
    
else
    echo "❌ Error: No VM information found!"
    echo "Create either:"
    echo "  - terraform_outputs.json (from Terraform)"
    echo "  - existing_vm.env (for existing VM)"
    exit 1
fi

echo "✅ Inventory generated:"
cat $INVENTORY_DIR/hosts.ini
