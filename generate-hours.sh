#!/bin/bash

# Script to generate all 24 hour directories with basic structure

set -e

REPO_ROOT="/home/claude/k8s-networking-24h"

# Hour topics and descriptions
declare -A HOURS
HOURS[02]="CNI Plugins Deep Dive (Calico, Flannel, Cilium)|Compare overlay vs underlay CNI approaches"
HOURS[03]="Services & kube-proxy Modes (iptables, IPVS)|Explain how Service ClusterIPs work"
HOURS[04]="DNS in Kubernetes (CoreDNS)|Understand Pod DNS resolution"
HOURS[05]="NodePort, LoadBalancer, ExternalName Services|Differentiate Service types and use cases"
HOURS[06]="Ingress Controllers & Ingress Resources|Deploy NGINX Ingress and create routing rules"
HOURS[08]="Advanced NetworkPolicy (Egress, DNS, CIDR)|Control egress traffic with NetworkPolicies"
HOURS[09]="Break + Micro-Review (Consolidation)|Active review and flashcard practice"
HOURS[10]="Container Network Interfaces (CNI) Deep Dive|Understand CNI plugin lifecycle"
HOURS[11]="Pod-to-Pod Communication Across Nodes|Trace packet flow across nodes"
HOURS[12]="Debugging Network Issues|Use kubectl debug and netshoot"
HOURS[13]="Service Mesh Basics (Istio/Linkerd)|Understand sidecar proxy model"
HOURS[14]="IPv6 and Dual-Stack Networking|Deploy pods with IPv4 and IPv6"
HOURS[15]="Headless Services & StatefulSets Networking|Create headless Services with stable identities"
HOURS[16]="EndpointSlices & Service Topology|Understand EndpointSlices vs Endpoints"
HOURS[17]="Network Performance & Observability|Measure network latency and throughput"
HOURS[18]="eBPF and Cilium Networking|Understand eBPF basics in networking"
HOURS[19]="Multi-Cluster Networking|Explore Cluster Mesh concepts"
HOURS[20]="Security Best Practices (mTLS, Pod Security)|Implement zero-trust NetworkPolicies"
HOURS[21]="Troubleshooting Case Studies|Debug real-world scenarios"
HOURS[22]="Production Patterns & Anti-Patterns|Identify common network anti-patterns"
HOURS[23]="Review & Spaced Repetition|Flashcard review and lab reruns"
HOURS[24]="Final Assessment|Comprehensive practical exam"

for hour_num in $(seq -w 2 24); do
    # Skip Hour 01 and 07 (already created)
    if [ "$hour_num" == "01" ] || [ "$hour_num" == "07" ]; then
        continue
    fi
    
    hour_dir="$REPO_ROOT/hour-$hour_num"
    
    # Create directory structure
    mkdir -p "$hour_dir"/{manifests,scripts}
    
    # Parse topic and objective
    IFS='|' read -r topic objective <<< "${HOURS[$hour_num]}"
    
    # Create README.md
    cat > "$hour_dir/README.md" << ENDREADME
# Hour $hour_num: $topic

## 🎯 Learning Objectives

$objective

## 📚 Study Method

- **Reading:** TBD minutes
- **Hands-on:** TBD minutes
- **Assessment:** TBD minutes

## 📖 Required Reading

[To be added - See main study plan document for details]

## 🧪 Hands-On Labs

\`\`\`bash
# Run the lab script
./lab.sh
\`\`\`

## 📝 Assessment Questions

[Assessment questions to be added]

## 🎴 Flashcard Prompts

[Flashcard prompts to be added]

## 🔗 Key Commands Reference

\`\`\`bash
# Key commands for Hour $hour_num
[To be added]
\`\`\`

## ⏭️ Next Steps

- Complete hands-on labs
- Answer assessment questions
- Create flashcards
- Move to Hour $(printf "%02d" $((10#$hour_num + 1)))

---

**Note:** This hour is part of the 24-hour Kubernetes Networking mastery plan.
Full details in the original study plan document.
ENDREADME

    # Create basic lab.sh script
    cat > "$hour_dir/lab.sh" << 'ENDLAB'
#!/bin/bash

set -e

echo "🧪 Hour $(basename $(pwd)): Lab Setup"
echo "====================================="
echo ""
echo "This lab script is a template."
echo "See README.md for manual lab instructions."
echo ""
echo "To be implemented: Automated lab setup for this hour."
echo ""
ENDLAB

    chmod +x "$hour_dir/lab.sh"
    
    # Create placeholder manifest
    cat > "$hour_dir/manifests/example.yaml" << 'ENDMANIFEST'
# Placeholder manifest
# Actual manifests to be added based on the hour's labs
apiVersion: v1
kind: ConfigMap
metadata:
  name: placeholder
data:
  note: "Replace with actual manifests for this hour"
ENDMANIFEST

    echo "Created hour-$hour_num: $topic"
done

echo ""
echo "✅ All hour directories generated!"
echo ""
echo "Structure created for hours: 02-24"
echo "(Hours 01 and 07 already have full content)"
echo ""
echo "Next steps:"
echo "  - Fill in detailed content for each hour"
echo "  - Add specific manifests and scripts"
echo "  - Create assessment questions"
echo ""
