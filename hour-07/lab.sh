#!/bin/bash

set -e

echo "🔒 Hour 7: NetworkPolicy - Lab Setup"
echo "===================================="
echo ""

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${YELLOW}Step 1: Creating test namespaces...${NC}"
kubectl create namespace frontend 2>/dev/null || echo "frontend exists"
kubectl create namespace backend 2>/dev/null || echo "backend exists"

echo -e "${GREEN}✓ Namespaces created${NC}"
echo ""

echo -e "${YELLOW}Step 2: Deploying test applications...${NC}"
kubectl run web -n frontend --image=nginx 2>/dev/null || echo "web exists"
kubectl run db -n backend --image=postgres --env="POSTGRES_PASSWORD=test123" 2>/dev/null || echo "db exists"

echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod/web -n frontend --timeout=60s 2>/dev/null || true
kubectl wait --for=condition=ready pod/db -n backend --timeout=60s 2>/dev/null || true

echo -e "${GREEN}✓ Applications deployed${NC}"
echo ""

echo -e "${YELLOW}Step 3: Exposing database service...${NC}"
kubectl expose pod db -n backend --port=5432 2>/dev/null || echo "Service exists"

echo -e "${GREEN}✓ Service created${NC}"
echo ""

echo -e "${YELLOW}Step 4: Installing curl in frontend pod...${NC}"
kubectl exec -n frontend web -- apt update -qq 2>/dev/null
kubectl exec -n frontend web -- apt install -y curl -qq 2>/dev/null

echo -e "${GREEN}✓ Tools installed${NC}"
echo ""

echo -e "${YELLOW}Step 5: Testing connectivity BEFORE NetworkPolicy...${NC}"
echo "Testing frontend -> backend (should work):"
if kubectl exec -n frontend web -- curl -s --max-time 5 db.backend:5432 2>&1 | grep -q "postgres"; then
    echo -e "${GREEN}✓ Connection successful (postgres response received)${NC}"
else
    echo -e "${RED}✗ Connection failed${NC}"
fi

echo ""
echo -e "${GREEN}════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Initial Setup Complete!${NC}"
echo -e "${GREEN}════════════════════════════════════${NC}"
echo ""
echo "Environment Ready:"
echo "  • frontend namespace: web pod (nginx + curl)"
echo "  • backend namespace: db pod (postgres) + service"
echo "  • NO NetworkPolicies yet (all traffic allowed)"
echo ""
echo "Next Steps:"
echo "  1. Apply default-deny policy:"
echo "     kubectl apply -f manifests/01-default-deny-backend.yaml"
echo ""
echo "  2. Test that frontend is now BLOCKED:"
echo "     kubectl exec -n frontend web -- curl --max-time 5 db.backend:5432"
echo ""
echo "  3. Apply allow policy:"
echo "     kubectl apply -f manifests/02-allow-frontend-to-backend.yaml"
echo ""
echo "  4. Label frontend namespace:"
echo "     kubectl label namespace frontend name=frontend"
echo ""
echo "  5. Test that frontend now WORKS:"
echo "     kubectl exec -n frontend web -- curl --max-time 5 db.backend:5432"
echo ""
echo "View current state:"
echo "  kubectl get pods -n frontend,backend -o wide"
echo "  kubectl get svc -n backend"
echo ""
