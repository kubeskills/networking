#!/bin/bash

set -e

echo "🧪 Hour 1: Pod Network Model - Lab Setup"
echo "========================================"
echo ""

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${YELLOW}Step 1: Deploying test Pods...${NC}"
kubectl run net-test-1 --image=nginx 2>/dev/null || echo "net-test-1 already exists"
kubectl run net-test-2 --image=nginx 2>/dev/null || echo "net-test-2 already exists"

echo "Waiting for Pods to be ready..."
kubectl wait --for=condition=ready pod/net-test-1 --timeout=60s
kubectl wait --for=condition=ready pod/net-test-2 --timeout=60s

echo ""
echo -e "${GREEN}✓ Pods deployed${NC}"
echo ""

echo -e "${YELLOW}Step 2: Pod Network Information${NC}"
echo "--------------------------------"
kubectl get pods net-test-1 net-test-2 -o wide

echo ""
POD1_IP=$(kubectl get pod net-test-1 -o jsonpath='{.status.podIP}')
POD2_IP=$(kubectl get pod net-test-2 -o jsonpath='{.status.podIP}')
POD1_NODE=$(kubectl get pod net-test-1 -o jsonpath='{.spec.nodeName}')
POD2_NODE=$(kubectl get pod net-test-2 -o jsonpath='{.spec.nodeName}')

echo "Pod 1: IP=$POD1_IP, Node=$POD1_NODE"
echo "Pod 2: IP=$POD2_IP, Node=$POD2_NODE"

if [ "$POD1_NODE" == "$POD2_NODE" ]; then
    echo -e "${YELLOW}⚠️  Both Pods on same node. Testing same-node connectivity.${NC}"
else
    echo -e "${GREEN}✓ Pods on different nodes. Testing cross-node connectivity.${NC}"
fi

echo ""
echo -e "${YELLOW}Step 3: Installing network tools in Pod 1...${NC}"
kubectl exec net-test-1 -- apt update -qq 2>/dev/null
kubectl exec net-test-1 -- apt install -y iputils-ping curl iproute2 -qq 2>/dev/null

echo -e "${GREEN}✓ Tools installed${NC}"
echo ""

echo -e "${YELLOW}Step 4: Testing Pod-to-Pod connectivity...${NC}"
echo "Pinging Pod 2 ($POD2_IP) from Pod 1..."
kubectl exec net-test-1 -- ping -c 3 $POD2_IP

echo ""
echo "Testing HTTP connectivity..."
kubectl exec net-test-1 -- curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://$POD2_IP

echo ""
echo -e "${GREEN}✓ Connectivity test passed!${NC}"
echo ""

echo -e "${YELLOW}Step 5: Inspecting Pod network configuration${NC}"
echo "Pod 1 IP address:"
kubectl exec net-test-1 -- ip addr show eth0 | grep "inet "

echo ""
echo "Pod 1 routing table:"
kubectl exec net-test-1 -- ip route

echo ""
echo -e "${YELLOW}Step 6: Node and Cluster Network Info${NC}"
echo "Node Pod CIDRs:"
kubectl get nodes -o jsonpath='{range .items[*]}{.metadata.name}{"\t"}{.spec.podCIDR}{"\n"}{end}'

echo ""
echo "Service CIDR (from cluster-info):"
kubectl cluster-info dump 2>/dev/null | grep -oP 'service-cluster-ip-range=\K[^"]+' | head -1

echo ""
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Lab Complete!${NC}"
echo -e "${BLUE}═══════════════════════════════════════${NC}"
echo ""
echo "Key Observations:"
echo "  • Every Pod has a unique IP"
echo "  • Pods can ping each other (no NAT needed)"
echo "  • HTTP connectivity works across Pods"
echo "  • Each node has a Pod CIDR subnet"
echo ""
echo "Next Steps:"
echo "  1. Review the pod network diagram in README.md"
echo "  2. Answer the assessment questions"
echo "  3. Create flashcards for retention"
echo "  4. Proceed to Hour 2"
echo ""
echo "To explore further:"
echo "  kubectl exec -it net-test-1 -- bash"
echo "  # Then try: ip addr, ip route, ping, curl, etc."
echo ""
