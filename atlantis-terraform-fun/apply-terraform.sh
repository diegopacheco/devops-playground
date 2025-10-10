#!/bin/bash
set -e

ATLANTIS_POD=$(kubectl get pods -n atlantis -l app=atlantis -o jsonpath='{.items[0].metadata.name}')

if [ -z "$ATLANTIS_POD" ]; then
  echo "Atlantis pod not found"
  exit 1
fi

echo "Cleaning up old terraform files..."
kubectl exec -n atlantis $ATLANTIS_POD -- sh -c "rm -rf /tmp/terraform" 2>/dev/null || true

echo "Copying terraform files to Atlantis pod..."
kubectl cp terraform $ATLANTIS_POD:/tmp/terraform -n atlantis

echo "Running terraform init..."
kubectl exec -n atlantis $ATLANTIS_POD -- sh -c "cd /tmp/terraform && terraform init"

echo "Running terraform plan..."
kubectl exec -n atlantis $ATLANTIS_POD -- sh -c "cd /tmp/terraform && terraform plan"

echo ""
read -p "Do you want to apply? (yes/no): " answer

if [ "$answer" = "yes" ]; then
  echo "Running terraform apply..."
  kubectl exec -n atlantis $ATLANTIS_POD -- sh -c "cd /tmp/terraform && terraform apply -auto-approve"

  echo ""
  echo "Terraform applied successfully!"
  echo ""
  echo "Checking created resources:"
  kubectl get ns terraform-app
  kubectl get all -n terraform-app
else
  echo "Apply cancelled"
fi
