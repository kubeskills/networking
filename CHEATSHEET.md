# Kubernetes Networking Cheatsheet

## 🌐 Network Model Fundamentals

### Core Principles
```
1. Every Pod gets its own IP address
2. Pods can communicate without NAT
3. Nodes can communicate with all Pods without NAT
4. Pod sees its own IP (no port translation)
```

### IP Ranges
```bash
# Pod CIDR (assigned per node)
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'
# Example: 10.244.0.0/24, 10.244.1.0/24, 10.244.2.0/24

# Service CIDR (cluster-wide virtual IPs)
kubectl cluster-info dump | grep -i service-cluster-ip-range
# Example: 10.96.0.0/12
```

---

## 📦 Pod Networking Commands

### Inspect Pod Network
```bash
# Get Pod IPs and nodes
kubectl get pods -o wide --all-namespaces

# Exec into Pod
kubectl exec -it <pod> -- bash

# Inside Pod: Check IP and routes
ip addr show eth0
ip route
cat /etc/resolv.conf

# Ping another Pod
ping <other-pod-ip>

# Check network interfaces
ip link show
```

### Test Connectivity
```bash
# Deploy test Pod
kubectl run nettest --image=nicolaka/netshoot -- sleep 3600

# Interactive shell
kubectl exec -it nettest -- bash

# From inside Pod
ping <pod-ip>
curl <pod-ip>:<port>
traceroute <pod-ip>
nslookup <service-name>
```

---

## 🔌 Services

### Service Types
| Type | Access | Use Case |
|------|--------|----------|
| ClusterIP | Internal only | Default, cluster-internal |
| NodePort | NodeIP:NodePort | External access via node ports (30000-32767) |
| LoadBalancer | External LB IP | Cloud provider load balancer |
| ExternalName | DNS CNAME | Alias for external service |

### Create Services
```bash
# Expose deployment as ClusterIP
kubectl expose deployment <name> --port=80 --target-port=8080

# Create NodePort service
kubectl expose deployment <name> --type=NodePort --port=80

# Create LoadBalancer
kubectl expose deployment <name> --type=LoadBalancer --port=80

# Create headless service
kubectl create service clusterip <name> --clusterip=None --tcp=80:80
```

### Inspect Services
```bash
# List services
kubectl get svc --all-namespaces

# Get service details
kubectl describe svc <service-name>

# Get ClusterIP
kubectl get svc <name> -o jsonpath='{.spec.clusterIP}'

# Get endpoints (backend Pods)
kubectl get endpoints <service-name>

# Check which Pods are selected
kubectl get pods -l <selector-from-svc>
```

### Test Services
```bash
# From within cluster
kubectl run test --rm -it --image=busybox -- wget -O- <service-name>:<port>

# Test ClusterIP directly
kubectl run test --rm -it --image=busybox -- wget -O- <cluster-ip>:<port>

# Check NodePort access (from outside)
curl http://<node-ip>:<node-port>
```

---

## 🌍 DNS

### DNS Format
```
<service>.<namespace>.svc.cluster.local → Service ClusterIP
<service>.<namespace>                    → Service ClusterIP (short)
<service>                                → Service ClusterIP (same namespace)

# StatefulSet Pods
<pod-name>.<service>.<namespace>.svc.cluster.local → Pod IP
```

### DNS Commands
```bash
# Test DNS from Pod
kubectl exec -it <pod> -- nslookup <service>
kubectl exec -it <pod> -- nslookup kubernetes.default

# Full FQDN
kubectl exec -it <pod> -- nslookup <service>.<namespace>.svc.cluster.local

# Check resolv.conf
kubectl exec -it <pod> -- cat /etc/resolv.conf
```

### CoreDNS Troubleshooting
```bash
# Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns --tail=50

# Check CoreDNS config
kubectl get configmap coredns -n kube-system -o yaml

# Edit CoreDNS config
kubectl edit configmap coredns -n kube-system

# Restart CoreDNS
kubectl rollout restart deployment coredns -n kube-system

# Scale CoreDNS
kubectl scale deployment coredns -n kube-system --replicas=3
```

---

## 🚪 Ingress

### Install NGINX Ingress Controller
```bash
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

# Wait for ready
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
```

### Create Ingress
```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: example-ingress
spec:
  ingressClassName: nginx
  rules:
  - host: myapp.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: myapp-service
            port:
              number: 80
```

### Ingress Commands
```bash
# List Ingress resources
kubectl get ingress --all-namespaces

# Describe Ingress
kubectl describe ingress <name>

# Get Ingress controller logs
kubectl logs -n ingress-nginx -l app.kubernetes.io/component=controller

# Test with curl (add host header)
curl -H "Host: myapp.local" http://localhost
```

---

## 🔒 NetworkPolicy

### Default Deny All Traffic
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: <namespace>
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress
```

### Allow DNS Egress
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-dns
spec:
  podSelector: {}
  policyTypes:
  - Egress
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
```

### Allow from Specific Namespace
```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend
  namespace: backend
spec:
  podSelector:
    matchLabels:
      app: api
  policyTypes:
  - Ingress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: frontend
    ports:
    - protocol: TCP
      port: 8080
```

### NetworkPolicy Commands
```bash
# List NetworkPolicies
kubectl get networkpolicy --all-namespaces

# Describe policy
kubectl describe networkpolicy <name> -n <namespace>

# Apply policy
kubectl apply -f <policy.yaml>

# Delete policy
kubectl delete networkpolicy <name> -n <namespace>

# Test if policy blocks traffic
kubectl exec -n <ns1> <pod1> -- curl <service-in-ns2>
```

---

## 🐛 Debugging & Troubleshooting

### Essential Debug Tools

**Deploy netshoot (Swiss Army knife)**
```bash
# Interactive pod
kubectl run netshoot --rm -it --image=nicolaka/netshoot -- bash

# Debug existing pod with ephemeral container
kubectl debug -it <pod> --image=nicolaka/netshoot --target=<pod>
```

### Network Inspection Commands
```bash
# Inside debug pod or container:

# Check interfaces
ip addr show
ip link show

# Check routes
ip route

# Check DNS
nslookup <service>
dig <service>

# Test connectivity
ping <ip>
curl -v <url>
telnet <ip> <port>
nc -zv <ip> <port>

# Check listening ports
netstat -tuln
ss -tuln

# Capture packets
tcpdump -i eth0 -n host <ip>
tcpdump -i any -n port 80

# Check iptables (needs NET_ADMIN)
iptables -t nat -L -n -v
iptables -L -n -v

# Connection tracking
conntrack -L
```

### Node-Level Debugging (kind)
```bash
# List kind nodes
docker ps --filter name=netlab

# Exec into node
docker exec -it <node-name> bash

# Inside node:
ip route
iptables -t nat -L KUBE-SERVICES -n | grep <service>
ls /etc/cni/net.d/
ls /opt/cni/bin/
journalctl -u kubelet | grep -i cni
```

### Common Troubleshooting Flows

**Service not reachable:**
```bash
# 1. Check if service exists
kubectl get svc <name>

# 2. Check endpoints
kubectl get endpoints <name>
# If empty: selector doesn't match any pods

# 3. Check pod labels
kubectl get pods -l <selector> --show-labels

# 4. Test direct pod access
kubectl exec <test-pod> -- curl <pod-ip>:<port>

# 5. Test service access
kubectl exec <test-pod> -- curl <service-name>:<port>

# 6. Check DNS
kubectl exec <test-pod> -- nslookup <service-name>

# 7. Check NetworkPolicies
kubectl get networkpolicy -n <namespace>
kubectl describe networkpolicy <name> -n <namespace>
```

**DNS not working:**
```bash
# 1. Check CoreDNS pods
kubectl get pods -n kube-system -l k8s-app=kube-dns

# 2. Check CoreDNS logs
kubectl logs -n kube-system -l k8s-app=kube-dns

# 3. Check resolv.conf in pod
kubectl exec <pod> -- cat /etc/resolv.conf

# 4. Test DNS directly
kubectl exec <pod> -- nslookup kubernetes.default

# 5. Check if NetworkPolicy blocks DNS
kubectl get networkpolicy -A

# 6. Test with IP instead of name
kubectl exec <pod> -- curl <service-ip>:<port>
```

**Cross-node connectivity fails:**
```bash
# 1. Check pod IPs and nodes
kubectl get pods -o wide

# 2. Check CNI pods
kubectl get pods -n kube-system

# 3. Ping from pod on node1 to pod on node2
kubectl exec <pod1> -- ping <pod2-ip>

# 4. Check node routes
docker exec <node> ip route

# 5. Capture traffic
docker exec <node> tcpdump -i eth0 -n

# 6. Check CNI config
docker exec <node> cat /etc/cni/net.d/*.conf
```

---

## 📊 kube-proxy & Service Implementation

### Check kube-proxy mode
```bash
# Get kube-proxy logs
kubectl logs -n kube-system -l k8s-app=kube-proxy | grep "Using"

# Output shows: "Using iptables Proxier" or "Using ipvs Proxier"
```

### iptables rules (for ClusterIP)
```bash
# On node:
docker exec <node> iptables -t nat -L KUBE-SERVICES -n

# Find service chain
docker exec <node> iptables -t nat -L KUBE-SVC-<hash> -n

# See endpoint chains
docker exec <node> iptables -t nat -L KUBE-SEP-<hash> -n
```

---

## 🏗️ CNI Plugins

### Check CNI Plugin
```bash
# List CNI pods
kubectl get pods -n kube-system | grep -iE 'cni|calico|flannel|weave|cilium'

# Check CNI config
docker exec <node> ls /etc/cni/net.d/
docker exec <node> cat /etc/cni/net.d/*.conf*

# Check CNI binaries
docker exec <node> ls /opt/cni/bin/
```

### Popular CNI Comparison
| CNI | Network Model | Performance | Features |
|-----|---------------|-------------|----------|
| Calico | L3 BGP or VXLAN | High | NetworkPolicy, encryption |
| Flannel | VXLAN overlay | Medium | Simple, easy setup |
| Cilium | eBPF | Very High | NetworkPolicy, observability, security |
| Weave | VXLAN overlay | Medium | Encryption, multicast |

---

## 📈 Performance & Metrics

### Benchmark with iperf3
```bash
# Server
kubectl run iperf-server --image=networkstatic/iperf3 -- -s

# Client (test throughput)
kubectl run iperf-client --rm -it --image=networkstatic/iperf3 -- \
  -c iperf-server.default.svc.cluster.local -t 30

# Expected: 1-10 Gbps depending on CNI and node network
```

### Latency Testing
```bash
kubectl run ping-test --rm -it --image=busybox -- sh
ping -c 100 <target-pod-ip>

# Expected RTT:
# Same node: < 1ms
# Different nodes (same DC): 1-5ms
# Cross-AZ: 5-20ms
```

---

## 🔐 Security Best Practices

### Zero-Trust Checklist
```bash
# 1. Default deny all traffic
kubectl apply -f default-deny-all.yaml -n <namespace>

# 2. Allow only necessary traffic
kubectl apply -f allow-specific.yaml

# 3. Always allow DNS
# (Include DNS egress in every namespace)

# 4. Test policies
kubectl exec <pod> -- curl <blocked-target>  # Should fail
kubectl exec <pod> -- curl <allowed-target>  # Should work

# 5. Monitor denials (Calico/Cilium)
kubectl logs -n calico-system -l k8s-app=calico-node | grep denied
```

### Common NetworkPolicy Patterns
```bash
# Allow ingress from specific app
podSelector:
  matchLabels:
    app: frontend

# Allow from specific namespace
namespaceSelector:
  matchLabels:
    name: trusted-ns

# Allow egress to specific CIDR
ipBlock:
  cidr: 10.0.0.0/8
  except:
  - 10.0.0.0/24

# Allow egress to internet (not cluster)
ipBlock:
  cidr: 0.0.0.0/0
  except:
  - 10.0.0.0/8
  - 172.16.0.0/12
  - 192.168.0.0/16
```

---

## 🚀 Quick Reference

### Most Used Commands
```bash
# Get everything about networking
kubectl get pods,svc,endpoints,ingress,networkpolicy -A -o wide

# Debug any pod connectivity
kubectl run debug --rm -it --image=nicolaka/netshoot -- bash

# Check service endpoints
kubectl get endpoints <service>

# Test DNS
kubectl exec <pod> -- nslookup <service>

# Check NetworkPolicies
kubectl get networkpolicy -A

# Describe ingress
kubectl describe ingress <name>

# Logs for CNI
kubectl logs -n kube-system <cni-pod>

# Logs for CoreDNS
kubectl logs -n kube-system -l k8s-app=kube-dns

# Node iptables
docker exec <node> iptables -t nat -L -n | grep <service>
```

### Emergency Troubleshooting
```bash
# Nothing works? Check these in order:
1. kubectl get nodes          # Nodes ready?
2. kubectl get pods -n kube-system  # CNI/CoreDNS running?
3. kubectl get pods -A        # All pods scheduled?
4. kubectl get svc            # Services exist?
5. kubectl get endpoints      # Endpoints populated?
6. kubectl get networkpolicy -A  # Policies blocking?
7. kubectl logs -n kube-system <coredns>  # DNS errors?
8. kubectl run debug --rm -it --image=nicolaka/netshoot  # Direct test
```

---

## 📚 External Resources

- **Kubernetes Networking Docs**: https://kubernetes.io/docs/concepts/services-networking/
- **NetworkPolicy Recipes**: https://github.com/ahmetb/kubernetes-network-policy-recipes
- **CNI Specification**: https://github.com/containernetworking/cni/blob/main/SPEC.md
- **Calico Docs**: https://docs.tigera.io/calico/latest
- **Cilium Docs**: https://docs.cilium.io/
- **Debugging Guide**: https://kubernetes.io/docs/tasks/debug/debug-cluster/

---

## 🎯 Performance Expectations

| Metric | Same Node | Cross-Node (DC) | Cross-AZ |
|--------|-----------|-----------------|----------|
| Latency (RTT) | < 1ms | 1-5ms | 5-20ms |
| Throughput | 10+ Gbps | 1-10 Gbps | 100Mbps - 1Gbps |
| DNS Lookup | < 10ms | < 10ms | < 20ms |
| Service Overhead | ~5% | ~10% | ~15% |

**Overlay (VXLAN) overhead:** ~10-15% throughput reduction vs native routing

---

**Print this cheatsheet for quick reference during labs! 📄**
