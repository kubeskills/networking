# Hour 1: Kubernetes Networking Fundamentals & Pod Network Model

## 🎯 Learning Objectives

By the end of this hour, you will:
1. Understand the Kubernetes flat network model (every Pod gets an IP)
2. Explain Pod-to-Pod communication requirements without NAT
3. Identify the role of CNI (Container Network Interface) plugins
4. Verify basic Pod networking across nodes

## 📚 Study Method

- **15 minutes:** Reading and conceptual understanding
- **30 minutes:** Hands-on labs and exploration
- **10 minutes:** Diagram drawing and concept mapping
- **5 minutes:** Assessment and flashcard creation

## 📖 Required Reading (15 minutes)

### 1. Kubernetes Network Model (10 minutes)

Read: [Kubernetes Network Model](https://kubernetes.io/docs/concepts/cluster-administration/networking/#the-kubernetes-network-model)

**Key Concepts:**
- Every Pod receives a unique IP address
- Pods can communicate with all other Pods without NAT
- Nodes can communicate with all Pods (and vice versa) without NAT
- The IP a Pod sees for itself is the same IP others see it as

### 2. CNI Overview (5 minutes)

Read: [CNI Specification Overview](https://github.com/containernetworking/cni/blob/main/SPEC.md) (skim)

**Key Concepts:**
- CNI plugins handle Pod network setup
- Plugins are invoked by kubelet during Pod creation
- Common plugins: Calico, Flannel, Cilium, Weave

## 🧪 Hands-On Labs (30 minutes)

### Lab 1: Deploy Test Pods (10 minutes)

```bash
# Run the lab script
./lab.sh

# Or manually:
kubectl run net-test-1 --image=nginx
kubectl run net-test-2 --image=nginx

# Check Pod IPs and nodes
kubectl get pods -o wide

# Note: Pods should be on different nodes if possible
```

### Lab 2: Test Pod-to-Pod Connectivity (15 minutes)

```bash
# Exec into first pod
kubectl exec -it net-test-1 -- bash

# Inside the pod, install network tools
apt update && apt install -y iputils-ping curl iproute2

# Check your own IP
ip addr show eth0

# Check routing table
ip route

# Ping the second pod (use IP from kubectl get pods -o wide)
ping -c 5 <net-test-2-ip>

# Curl the nginx service
curl <net-test-2-ip>

# Exit pod
exit
```

### Lab 3: Inspect Node Networking (5 minutes)

```bash
# Get node IPs and Pod CIDRs
kubectl get nodes -o wide
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'

# Check cluster network info
kubectl cluster-info dump | grep -i cidr

# Check CNI configuration on node (for kind)
docker ps --filter name=netlab
docker exec <node-name> cat /etc/cni/net.d/10-kindnet.conflist
```

## 📝 Assessment Questions (5 minutes)

Answer these questions to check your understanding:

1. **Why can Pods on different nodes communicate without NAT?**
   <details>
   <summary>Answer</summary>
   Because Kubernetes requires a flat network where every Pod has a unique cluster-wide IP, and the CNI plugin configures routing so all Pods can reach each other directly.
   </details>

2. **What does CNI stand for and what does it do?**
   <details>
   <summary>Answer</summary>
   Container Network Interface. It's a specification and set of plugins that configure network interfaces for containers/Pods, including IP allocation and routing setup.
   </details>

3. **Run `ip route` inside a Pod. What routes exist and why?**
   <details>
   <summary>Answer</summary>
   You'll see:
   - A default route (typically via the node's IP)
   - A route for the Pod's own subnet
   - These enable the Pod to reach other Pods and external networks
   </details>

## 🎴 Flashcard Prompts

Create these flashcards for spaced repetition:

**Card 1:**
- Front: "What are the 3 main requirements of the Kubernetes network model?"
- Back: "1) Pod-to-Pod communication without NAT, 2) Node-to-Pod communication without NAT, 3) Pod sees its own IP (no port translation)"

**Card 2:**
- Front: "What does a CNI plugin do?"
- Back: "Allocates IP addresses to Pods, creates network interfaces, and sets up routing when Pods are created/destroyed"

## 🖼️ Diagram Exercise

Draw this diagram on paper (or digitally):

```
┌─────────────────────────────────────────────────────┐
│                   Cluster Network                    │
│                                                      │
│  ┌──────────────┐              ┌──────────────┐    │
│  │   Node 1     │              │   Node 2     │    │
│  │              │              │              │    │
│  │  ┌────────┐  │              │  ┌────────┐  │    │
│  │  │ Pod A  │  │              │  │ Pod B  │  │    │
│  │  │10.244. │──┼──────────────┼─▶│10.244. │  │    │
│  │  │  0.5   │  │   Flat Net   │  │  1.3   │  │    │
│  │  └────────┘  │   (No NAT)   │  └────────┘  │    │
│  │              │              │              │    │
│  │  Pod CIDR:   │              │  Pod CIDR:   │    │
│  │  10.244.0/24 │              │  10.244.1/24 │    │
│  └──────────────┘              └──────────────┘    │
│                                                      │
│  CNI Plugin: Handles IP allocation & routing        │
└─────────────────────────────────────────────────────┘
```

## 🔗 Key Commands Reference

```bash
# Essential commands for this hour
kubectl get pods -o wide                    # View Pod IPs and nodes
kubectl exec -it <pod> -- ip addr          # Check Pod IP
kubectl exec -it <pod> -- ip route         # Check Pod routing
kubectl get nodes -o jsonpath='{.items[*].spec.podCIDR}'  # Node Pod CIDRs
docker exec <node> cat /etc/cni/net.d/*    # CNI config (kind clusters)
```

## ⏭️ Next Steps

Once you've completed this hour:
1. Ensure both test Pods can ping each other
2. Verify you understand why no NAT is needed
3. Create your flashcards
4. Move to **Hour 2: CNI Plugins Deep Dive**

## 📚 Additional Resources (Optional)

- [A Guide to the Kubernetes Networking Model](https://sookocheff.com/post/kubernetes/understanding-kubernetes-networking-model/)
- [Life of a Packet in Kubernetes](https://dramasamy.medium.com/life-of-a-packet-in-kubernetes-part-1-f9bc0909e051)

---

**Time Check:** You should complete this hour in approximately 60 minutes. If you're ahead, review the concepts. If behind, focus on the hands-on labs and skip optional reading.
