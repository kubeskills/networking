# 12-Hour Priority Track: Kubernetes Networking

Focused curriculum covering essential networking concepts in half the time.

## Schedule Overview

Covers: **Core concepts, Services, NetworkPolicies, Ingress, Troubleshooting**

| Hour | Topic | Focus |
|------|-------|-------|
| 1-2 | Pod network model, CNI, Services (ClusterIP) | Fundamentals |
| 3 | DNS, basic troubleshooting tools | Core skills |
| 4-5 | NetworkPolicies (default-deny, allow rules, DNS) | Security |
| 6 | Ingress controllers (NGINX) | External access |
| 7-8 | StatefulSet networking, headless Services | Advanced patterns |
| 9 | Debugging case studies | Practical skills |
| 10-11 | Hands-on consolidation, review | Reinforce learning |
| 12 | Final assessment (simplified) | Validation |

## Detailed Breakdown

### Hours 1-2: Foundations
- **Objective:** Understand Pod networking, CNI, and Services
- **Labs:** 
  - Deploy Pods, test connectivity
  - Create ClusterIP Services
  - Test Service discovery via DNS
- **Key Skills:** kubectl basics, Pod-to-Pod communication, Service access

### Hour 3: DNS & Tools
- **Objective:** CoreDNS troubleshooting, netshoot tools
- **Labs:**
  - DNS resolution testing
  - Deploy netshoot for debugging
  - Practice nslookup, curl, ping
- **Key Skills:** DNS troubleshooting, debug pod deployment

### Hours 4-5: NetworkPolicies ⭐ CRITICAL
- **Objective:** Master pod isolation and zero-trust networking
- **Labs:**
  - Default-deny policies
  - Allow specific namespace/pod traffic
  - DNS egress exceptions
  - Test enforcement
- **Key Skills:** Write policies from scratch, understand selectors

### Hour 6: Ingress
- **Objective:** Expose services externally with Ingress
- **Labs:**
  - Install NGINX Ingress Controller
  - Create host-based routing
  - Test with curl
- **Key Skills:** Ingress resource creation, controller management

### Hours 7-8: Advanced Patterns
- **Objective:** StatefulSets, headless Services, stable network identities
- **Labs:**
  - Deploy StatefulSet with headless Service
  - Test individual Pod DNS
  - Compare with Deployments
- **Key Skills:** Stateful app networking, DNS patterns

### Hour 9: Debugging
- **Objective:** Systematic troubleshooting approach
- **Labs:**
  - Service not resolving
  - NetworkPolicy blocking traffic
  - DNS failures
- **Key Skills:** Debug workflow, log analysis

### Hours 10-11: Practice & Review
- **Objective:** Solidify knowledge through repetition
- **Activities:**
  - Re-run critical labs
  - Flashcard review
  - Speed drills (deploy → expose → protect in <10min)
  - Fill knowledge gaps

### Hour 12: Assessment
- **Objective:** Validate competency
- **Tasks:**
  - Deploy 3-tier app
  - Configure networking stack
  - Apply security policies
  - Debug introduced issues
- **Pass Criteria:** 75/100

## What's Skipped (vs 24h track)

To save time, this track omits:
- Deep CNI internals
- Service mesh concepts
- eBPF/Cilium deep dive
- Multi-cluster networking
- IPv6/dual-stack
- EndpointSlices details
- Advanced performance tuning

**You can return to these topics after completing the 12h track.**

## Study Tips for Accelerated Learning

1. **Skip optional reading** - stick to required docs only
2. **Type commands** - don't just read, do
3. **Focus on labs** - 70% hands-on, 30% theory
4. **Use flashcards** - create during breaks
5. **Ask "why"** - understand concepts, not just commands

## Success Metrics

By hour 12, you should be able to:
- ✅ Explain Pod-to-Pod communication
- ✅ Create and debug Services
- ✅ Write NetworkPolicies from memory
- ✅ Deploy and configure Ingress
- ✅ Troubleshoot common network issues
- ✅ Apply zero-trust principles

## Next Steps After Completion

1. Take the full final assessment from Hour 24
2. Review hours 10-23 from 24h track for advanced topics
3. Practice on real clusters (EKS, GKE, AKS)
4. Explore service mesh (Istio, Linkerd)

---

**Ready to start?** Begin with [Hour 1](hour-01/)
