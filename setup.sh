#!/bin/bash

set -e

echo "🚀 Kubernetes Networking 24h - Setup Script"
echo "==========================================="
echo ""

# Color codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Detect OS
OS="$(uname -s)"
ARCH="$(uname -m)"

echo "Detected: $OS $ARCH"
echo ""

# Check prerequisites
echo "📋 Checking prerequisites..."

# Check Docker
if ! command -v docker &> /dev/null; then
    echo -e "${RED}❌ Docker not found. Please install Docker first.${NC}"
    echo "Visit: https://docs.docker.com/get-docker/"
    exit 1
fi
echo -e "${GREEN}✓ Docker found${NC}"

# Check if Docker is running
if ! docker info &> /dev/null; then
    echo -e "${RED}❌ Docker daemon not running. Please start Docker.${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Docker daemon running${NC}"

# Install kubectl if not present
if ! command -v kubectl &> /dev/null; then
    echo -e "${YELLOW}⚙️  Installing kubectl...${NC}"
    
    if [[ "$OS" == "Linux" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/$ARCH/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
    elif [[ "$OS" == "Darwin" ]]; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/$ARCH/kubectl"
        chmod +x kubectl
        sudo mv kubectl /usr/local/bin/
    fi
    echo -e "${GREEN}✓ kubectl installed${NC}"
else
    echo -e "${GREEN}✓ kubectl found${NC}"
fi

# Install kind if not present
if ! command -v kind &> /dev/null; then
    echo -e "${YELLOW}⚙️  Installing kind...${NC}"
    
    if [[ "$OS" == "Linux" ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-$ARCH
    elif [[ "$OS" == "Darwin" ]]; then
        curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-darwin-$ARCH
    fi
    
    chmod +x ./kind
    sudo mv ./kind /usr/local/bin/kind
    echo -e "${GREEN}✓ kind installed${NC}"
else
    echo -e "${GREEN}✓ kind found${NC}"
fi

# Check for existing clusters
if kind get clusters 2>/dev/null | grep -q "^netlab$"; then
    echo -e "${YELLOW}⚠️  Cluster 'netlab' already exists.${NC}"
    read -p "Delete and recreate? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        kind delete cluster --name netlab
    else
        echo "Using existing cluster."
        kubectl cluster-info --context kind-netlab
        exit 0
    fi
fi

# Create kind cluster
echo ""
echo -e "${YELLOW}🔨 Creating kind cluster 'netlab'...${NC}"

cat <<EOF | kind create cluster --name netlab --config=-
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 80
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
- role: worker
networking:
  podSubnet: "10.244.0.0/16"
  serviceSubnet: "10.96.0.0/12"
EOF

echo -e "${GREEN}✓ Cluster created${NC}"

# Set kubectl context
kubectl cluster-info --context kind-netlab

# Verify nodes
echo ""
echo "📊 Cluster Status:"
kubectl get nodes -o wide

# Create test namespaces
echo ""
echo -e "${YELLOW}📦 Creating test namespaces...${NC}"
kubectl create namespace frontend || true
kubectl create namespace backend || true
kubectl create namespace database || true
kubectl label namespace frontend name=frontend --overwrite || true
kubectl label namespace backend name=backend --overwrite || true
kubectl label namespace database name=database --overwrite || true
echo -e "${GREEN}✓ Namespaces created${NC}"

# Install metrics-server (optional but useful)
echo ""
echo -e "${YELLOW}📊 Installing metrics-server...${NC}"
kubectl apply -f https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml

# Patch metrics-server for kind
kubectl patch deployment metrics-server -n kube-system --type='json' -p='[
  {
    "op": "add",
    "path": "/spec/template/spec/containers/0/args/-",
    "value": "--kubelet-insecure-tls"
  }
]' || true

echo -e "${GREEN}✓ metrics-server installed${NC}"

# Summary
echo ""
echo "=========================================="
echo -e "${GREEN}✅ Setup Complete!${NC}"
echo "=========================================="
echo ""
echo "Cluster Info:"
echo "  Name: netlab"
echo "  Nodes: 3 (1 control-plane, 2 workers)"
echo "  Pod CIDR: 10.244.0.0/16"
echo "  Service CIDR: 10.96.0.0/12"
echo ""
echo "Quick Commands:"
echo "  kubectl get nodes"
echo "  kubectl get pods -A"
echo "  kind get clusters"
echo ""
echo "Next Steps:"
echo "  cd hour-01/"
echo "  cat README.md"
echo "  ./lab.sh"
echo ""
echo "To delete cluster when done:"
echo "  kind delete cluster --name netlab"
echo ""
echo -e "${GREEN}Happy learning! 🚀${NC}"
