# Hour 7: NetworkPolicy Basics & Pod Isolation

## 🎯 Learning Objectives

By the end of this hour, you will:
1. Understand default-deny NetworkPolicy patterns
2. Write allow rules for specific traffic flows
3. Test NetworkPolicy enforcement in real scenarios
4. Implement zero-trust networking principles

## 📚 Study Method

- **15 minutes:** Theory and NetworkPolicy structure
- **35 minutes:** Hands-on policy creation and testing
- **10 minutes:** Testing policy enforcement

## 📖 Required Reading (15 minutes)

### NetworkPolicy Concepts

Read: [Kubernetes NetworkPolicy](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

**Key Concepts:**
- By default, Pods accept traffic from any source (open network)
- NetworkPolicies define allowed traffic (whitelist model)
- Policies are namespaced and select Pods via labels
- Multiple policies are additive (OR logic)
- Requires a CNI plugin that supports NetworkPolicy (Calico, Cilium, etc.)

### NetworkPolicy Structure

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: example-policy
  namespace: default
spec:
  podSelector:           # Which Pods this applies to
    matchLabels:
      app: myapp
  policyTypes:           # Ingress, Egress, or both
  - Ingress
  - Egress
  ingress:               # Allowed incoming traffic
  - from:
    - podSelector:       # From Pods with label
        matchLabels:
          app: frontend
    ports:
    - protocol: TCP
      port: 8080
  egress:                # Allowed outgoing traffic
  - to:
    - podSelector:
        matchLabels:
          app: database
    ports:
    - protocol: TCP
      port: 5432
```

## 🧪 Hands-On Labs (35 minutes)

### Lab 1: Deploy Test Application (5 minutes)

```bash
# Run the full lab setup
./lab.sh

# This creates:
# - frontend namespace with nginx pod
# - backend namespace with postgres pod
# - Tests connectivity before policies
```

### Lab 2: Implement Default Deny (10 minutes)

```bash
# Apply default-deny to backend namespace
kubectl apply -f manifests/01-default-deny-backend.yaml

# Test connectivity - should now FAIL
kubectl exec -n frontend web -- curl --max-time 5 db.backend:5432
# Expected: timeout/connection refused

# Verify policy is applied
kubectl get networkpolicy -n backend
kubectl describe networkpolicy default-deny -n backend
```

### Lab 3: Allow Specific Traffic (15 minutes)

```bash
# Apply policy to allow frontend -> backend
kubectl apply -f manifests/02-allow-frontend-to-backend.yaml

# Test again - should still FAIL
kubectl exec -n frontend web -- curl --max-time 5 db.backend:5432
# Why? Because namespace labels aren't set!

# Add namespace label
kubectl label namespace frontend name=frontend

# Test again - should now SUCCEED
kubectl exec -n frontend web -- curl --max-time 5 db.backend:5432
# Expected: postgres connection message

# Try from different namespace - should FAIL
kubectl run test -n default --rm -it --image=busybox -- \
  wget --timeout=5 -O- db.backend.svc.cluster.local:5432
```

### Lab 4: Test Policy Enforcement (5 minutes)

```bash
# Create unauthorized pod in frontend namespace
kubectl run unauthorized -n frontend --image=nginx

# Try to access backend - should FAIL (no matching label)
kubectl exec -n frontend unauthorized -- curl --max-time 5 db.backend:5432

# Add correct label
kubectl label pod unauthorized -n frontend app=web

# Try again - should now SUCCEED
kubectl exec -n frontend unauthorized -- curl --max-time 5 db.backend:5432
```

## 📂 Manifest Files

All manifests are in the `manifests/` directory:

### 01-default-deny-backend.yaml
Blocks all ingress and egress traffic to backend namespace.

### 02-allow-frontend-to-backend.yaml
Allows ingress from frontend namespace to backend on port 5432.

### 03-allow-dns.yaml
Allows egress to kube-system for DNS resolution (critical!).

### 04-complete-policy-set.yaml
Production-ready policy stack with DNS allowed.

## 📝 Assessment Questions

1. **What happens without any NetworkPolicy in a namespace?**
   <details>
   <summary>Answer</summary>
   All traffic is allowed (default-allow). Pods can receive traffic from any source and send traffic to any destination.
   </details>

2. **Do NetworkPolicies affect egress by default?**
   <details>
   <summary>Answer</summary>
   No. You must explicitly specify `policyTypes: [Egress]` and define egress rules. Omitting egress from policyTypes means all egress is allowed.
   </details>

3. **How do you allow traffic from specific namespaces?**
   <details>
   <summary>Answer</summary>
   Use `namespaceSelector` with label matching. Example:
   ```yaml
   from:
   - namespaceSelector:
       matchLabels:
         name: frontend
   ```
   </details>

4. **Why is DNS often blocked by default-deny policies?**
   <details>
   <summary>Answer</summary>
   DNS runs in kube-system namespace on UDP port 53. A default-deny egress policy blocks this unless explicitly allowed.
   </details>

## 🎴 Flashcard Prompts

**Card 1:**
- Front: "What does a default-deny NetworkPolicy look like?"
- Back: 
  ```yaml
  spec:
    podSelector: {}
    policyTypes:
    - Ingress
    - Egress
  ```

**Card 2:**
- Front: "How do you allow DNS in a namespace with default-deny egress?"
- Back: 
  ```yaml
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          kubernetes.io/metadata.name: kube-system
    ports:
    - protocol: UDP
      port: 53
  ```

## 🔗 Key Commands Reference

```bash
# Apply NetworkPolicy
kubectl apply -f <policy.yaml>

# List policies
kubectl get networkpolicy -A
kubectl get netpol -n <namespace>

# Describe policy
kubectl describe networkpolicy <name> -n <namespace>

# Test connectivity
kubectl exec -n <ns> <pod> -- curl <target>

# Check pod labels
kubectl get pods -n <ns> --show-labels

# Label namespace
kubectl label namespace <ns> name=<value>

# Delete policy
kubectl delete networkpolicy <name> -n <ns>
```

## 🖼️ Policy Flow Diagram

```
┌──────────────┐         NetworkPolicy        ┌──────────────┐
│   Frontend   │         allows traffic       │   Backend    │
│  Namespace   │  ───────────────────────▶   │  Namespace   │
│              │                               │              │
│  ┌────────┐  │   podSelector: app=web       │  ┌────────┐  │
│  │  web   │──┼────────────────────────────▶ │  │   db   │  │
│  │  pod   │  │   namespaceSelector:         │  │  pod   │  │
│  └────────┘  │   name=frontend              │  └────────┘  │
│              │   port: 5432                  │              │
└──────────────┘                               └──────────────┘
       ▲                                              │
       │                                              │
       └──────────────────────────────────────────────┘
              DNS allowed via egress to kube-system
```

## ⚠️ Common Pitfalls

1. **Forgetting DNS:** Always allow egress to kube-system for DNS
2. **Namespace labels:** Policies reference namespace labels, not names
3. **Additive nature:** Multiple policies OR together (not AND)
4. **Empty podSelector:** `{}` matches ALL pods in namespace
5. **Policy types:** Omitting `policyTypes` means ingress only (default)

## 🔐 Zero-Trust Principles

Best practices for production NetworkPolicies:

1. **Default-deny everything:** Start with deny-all in every namespace
2. **Least privilege:** Only allow necessary connections
3. **Explicit DNS:** Always include DNS egress exception
4. **Document policies:** Use comments/annotations to explain purpose
5. **Test thoroughly:** Verify both allowed and blocked traffic

## ⏭️ Next Steps

After completing this hour:
1. Ensure you can write a default-deny policy from memory
2. Understand podSelector vs namespaceSelector
3. Know how to allow DNS
4. Move to **Hour 8: Advanced NetworkPolicy**

## 📚 Additional Resources

- [NetworkPolicy Recipes](https://github.com/ahmetb/kubernetes-network-policy-recipes)
- [Calico NetworkPolicy Guide](https://docs.tigera.io/calico/latest/network-policy/)

---

**Time Check:** Complete in 60 minutes. Focus on hands-on practice with policies.
