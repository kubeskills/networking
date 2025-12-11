# Final Assessment: Kubernetes Networking Practical Exam

## 🎯 Objective

Deploy a complete, secure, production-like microservices stack demonstrating mastery of:
- Multi-namespace architecture
- Services (ClusterIP, headless, NodePort)
- Ingress routing
- NetworkPolicies (zero-trust)
- Troubleshooting and debugging

## ⏱️ Time Limit

**45 minutes** for main tasks + **10 minutes** for debugging challenge

## 📋 Requirements

### Part 1: Infrastructure Setup (10 minutes)

**Create 3 namespaces:**
```bash
frontend
backend
database
```

**Label namespaces for NetworkPolicy selection:**
```bash
name=frontend
name=backend
name=database
```

### Part 2: Application Deployment (15 minutes)

**Frontend Namespace:**
- Deploy: 2 nginx Pods (label: `app=web`)
- Service: ClusterIP on port 80

**Backend Namespace:**
- Deploy: 2 Pods using `hashicorp/http-echo` (label: `app=api`)
- Service: ClusterIP on port 5678

**Database Namespace:**
- Deploy: StatefulSet with 2 replicas (any database image)
- Service: Headless Service for StatefulSet

### Part 3: External Access (5 minutes)

**Create Ingress with two routes:**
- `frontend.local/` → frontend Service
- `api.local/` → backend Service

### Part 4: NetworkPolicies (10 minutes)

**Implement zero-trust networking:**

1. **Default deny all traffic** in all 3 namespaces
2. **Frontend policies:**
   - Can access backend API
   - Can access external internet (egress)
   - Can use DNS
3. **Backend policies:**
   - Can receive from frontend only
   - Can access database only
   - Can use DNS
4. **Database policies:**
   - Can receive from backend only
   - Can use DNS

### Part 5: Testing & Verification (5 minutes)

**Demonstrate:**
1. External access via Ingress works
2. Frontend → Backend → Database connectivity chain works
3. Unauthorized access is blocked
4. DNS resolution works from all Pods

### Part 6: Debug Challenge (10 minutes) ⚠️

**Scenario:** An intentionally broken NetworkPolicy is applied.

**Your task:**
- Identify the issue
- Fix the policy
- Verify connectivity is restored

## 📊 Grading Rubric

| Criteria | Points | Pass Threshold |
|----------|--------|----------------|
| **Namespaces & Labels** | 5 | 4/5 |
| **Pods Running** | 10 | 8/10 |
| **Services Correct** | 10 | 8/10 |
| **StatefulSet + Headless** | 10 | 7/10 |
| **Ingress Routing** | 10 | 8/10 |
| **NetworkPolicies Applied** | 20 | 15/20 |
| **Connectivity Chain Works** | 15 | 12/15 |
| **DNS Functional** | 5 | 4/5 |
| **Debug Challenge** | 10 | 7/10 |
| **YAML Quality** | 5 | 3/5 |
| **TOTAL** | **100** | **75+** |

## 📝 Submission Checklist

- [ ] All YAML manifests in `submission/` directory
- [ ] Test commands and outputs in `submission/test-results.txt`
- [ ] One-page design doc explaining NetworkPolicy strategy
- [ ] Screenshots of: Pods, Services, Ingress, NetworkPolicies

## 🚀 Getting Started

```bash
cd final-assessment/
# Create your manifests
mkdir submission
# Start building!
```

## 💡 Hints

- Use `kubectl create` with `--dry-run=client -o yaml` to generate manifests
- Test each component before moving to next
- Check endpoints: `kubectl get endpoints <service>`
- Debug with: `kubectl run debug --rm -it --image=nicolaka/netshoot`
- Review Hour 7 for NetworkPolicy patterns

## 🎓 Success Criteria

You pass if you score **75/100 or higher** and can demonstrate:
- Working multi-tier application
- Secure network segmentation
- External access via Ingress
- Systematic troubleshooting approach

## 📚 Reference Materials Allowed

- CHEATSHEET.md
- Your own notes and flashcards
- Official Kubernetes documentation
- Hour-by-hour lab materials from this course

## 🔗 Solution

After submitting your attempt, check `solution/` directory for reference implementation.

---

**Good luck! This assessment validates your 24 hours of learning. 🚀**
