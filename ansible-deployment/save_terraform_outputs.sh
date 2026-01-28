#!/bin/bash
# Run this after Terraform apply

TERRAFORM_DIR="${1:-../terraform/parent}"

cd $TERRAFORM_DIR

# Save all outputs as JSON
terraform output -json > ../../ansible-deployment/terraform_outputs.json

echo "✅ Terraform outputs saved"
