#!/bin/bash

# Reset cluster to clean state

set -e

echo "🔄 Cluster Reset"
echo "==============="
echo ""
echo "⚠️  WARNING: This will delete the current cluster and create a new one."
echo ""
read -p "Continue? (y/N): " -n 1 -r
echo

if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Cancelled."
    exit 0
fi

echo ""
echo "Deleting existing cluster..."
kind delete cluster --name netlab 2>/dev/null || echo "No cluster to delete"

echo ""
echo "Re-running setup..."
cd "$(dirname "$0")/.."
./setup.sh

echo ""
echo "✅ Cluster reset complete!"
echo ""
