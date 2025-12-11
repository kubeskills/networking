# 🚀 Accelerate Your Kubernetes Networking Skills in 24 Hours

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Kubernetes](https://img.shields.io/badge/Kubernetes-v1.28+-blue.svg)](https://kubernetes.io/)

A complete, hands-on learning path to master Kubernetes networking concepts in 24 hours through structured labs, manifests, and real-world scenarios.

## 📋 Overview

This repository provides everything you need to go from Kubernetes networking beginner to competent practitioner in 24 focused hours. Each hour includes:

- **Detailed learning objectives**
- **Ready-to-use YAML manifests**
- **Executable shell scripts**
- **Hands-on lab exercises**
- **Assessment checkpoints**
- **Flashcard prompts for retention**

## 🎯 Target Audience

- **Skill Level:** Intermediate (basic Linux/container knowledge, new to K8s networking)
- **Prerequisites:** Docker installed, basic kubectl familiarity
- **Time Commitment:** 24 hours (can compress to 12h or 8h priority tracks)

## 🛠️ Quick Start

### Prerequisites Installation

```bash
# Clone this repository
git clone https://github.com/kubeskills/networking.git
cd networking

# Run setup script (installs kind, kubectl, and creates test cluster)
./setup.sh

# Verify installation
kubectl get nodes
```

### Alternative: Browser-Based (No Installation)

Use **Killercoda Kubernetes Labs**: https://killercoda.com/

## 📚 Course Structure

| Hour | Topic | Key Concepts | Lab Time |
|------|-------|--------------|----------|
| **01** | [Pod Network Model & Fundamentals](hour-01/) | Flat networking, CNI basics | 30m |
| **02** | [CNI Plugins Deep Dive](hour-02/) | Calico, Flannel, Cilium comparison | 30m |
| **03** | [Services & kube-proxy](hour-03/) | ClusterIP, iptables, IPVS | 25m |
| **04** | [DNS in Kubernetes](hour-04/) | CoreDNS, resolution, troubleshooting | 30m |
| **05** | [Service Types](hour-05/) | NodePort, LoadBalancer, ExternalName | 35m |
| **06** | [Ingress Controllers](hour-06/) | NGINX Ingress, routing rules | 30m |
| **07** | [NetworkPolicy Basics](hour-07/) | Pod isolation, allow rules | 35m |
| **08** | [Advanced NetworkPolicy](hour-08/) | Egress, DNS exceptions, CIDR | 35m |
| **09** | [🔥 Break & Review](hour-09/) | Consolidation, flashcards | 45m |
| **10** | [CNI Deep Dive](hour-10/) | Plugin lifecycle, configs | 25m |
| **11** | [Cross-Node Communication](hour-11/) | Packet tracing, VXLAN vs BGP | 30m |
| **12** | [Network Debugging](hour-12/) | netshoot, tcpdump, troubleshooting | 40m |
| **13** | [Service Mesh Basics](hour-13/) | Istio/Linkerd concepts | 20m |
| **14** | [IPv6 & Dual-Stack](hour-14/) | Dual-stack configuration | 25m |
| **15** | [Headless Services & StatefulSets](hour-15/) | Stable network identities | 35m |
| **16** | [EndpointSlices](hour-16/) | Scalability improvements | 25m |
| **17** | [Network Performance](hour-17/) | Benchmarking, observability | 30m |
| **18** | [eBPF & Cilium](hour-18/) | Modern networking with eBPF | 20m |
| **19** | [Multi-Cluster Networking](hour-19/) | Cluster Mesh, federation | 20m |
| **20** | [Security Best Practices](hour-20/) | Zero-trust, mTLS | 25m |
| **21** | [Troubleshooting Case Studies](hour-21/) | Real-world debugging | 45m |
| **22** | [Production Patterns](hour-22/) | Anti-patterns, best practices | 20m |
| **23** | [Review & Spaced Repetition](hour-23/) | Flashcard review, lab reruns | 30m |
| **24** | [Final Assessment](hour-24/) | Comprehensive practical exam | 45m |

## 📖 How to Use This Repository

### Hour-by-Hour Approach

```bash
# Navigate to each hour's directory
cd hour-01/

# Read the hour's README
cat README.md

# Run the lab script
./lab.sh

# Apply manifests as instructed
kubectl apply -f manifests/

# Complete assessment questions
cat assessment.md
```

### Compressed Schedules

**Short on time?**

- **12-Hour Priority Track:** See [`COMPRESSED-12H.md`](COMPRESSED-12H.md)
- **8-Hour Critical Track:** See [`COMPRESSED-8H.md`](COMPRESSED-8H.md)

### Learning Techniques

- **Pomodoro:** 25m focus + 5m breaks (automated timer in `scripts/pomodoro.sh`)
- **Flashcards:** Anki-compatible deck in [`flashcards/`](flashcards/)
- **Active Recall:** Assessment questions at end of each hour
- **Spaced Repetition:** Review schedule in [`STUDY-SCHEDULE.md`](STUDY-SCHEDULE.md)

## 🎓 Certification Alignment

This course aligns with:
- ✅ **CKA (Certified Kubernetes Administrator)** - Networking domain (20%)
- ✅ **CKAD (Certified Kubernetes Application Developer)** - Services & Networking (20%)
- ✅ **CKS (Certified Kubernetes Security Specialist)** - NetworkPolicies (15%)

## 📝 Cheatsheet

Quick reference for all essential commands and patterns: [`CHEATSHEET.md`](CHEATSHEET.md)

## 🧪 Final Assessment

Complete practical exam in [`final-assessment/`](final-assessment/) includes:
- Multi-tier application deployment
- Full networking stack (Services, Ingress, NetworkPolicies)
- Debugging scenario
- Grading rubric (pass: 75/100)

## 📦 Repository Structure

```
k8s-networking-24h/
├── README.md                    # This file
├── setup.sh                     # One-command setup script
├── CHEATSHEET.md               # One-page reference
├── COMPRESSED-12H.md           # 12-hour priority track
├── COMPRESSED-8H.md            # 8-hour critical track
├── STUDY-SCHEDULE.md           # Spaced repetition schedule
├── hour-01/                    # Hour 1: Pod Network Fundamentals
│   ├── README.md
│   ├── lab.sh
│   ├── manifests/
│   └── assessment.md
├── hour-02/                    # Hour 2: CNI Plugins
│   ├── README.md
│   ├── lab.sh
│   ├── manifests/
│   └── assessment.md
├── [hour-03 through hour-24]/  # Similar structure
├── final-assessment/           # Hour 24 comprehensive exam
│   ├── README.md
│   ├── scenario.md
│   ├── rubric.md
│   └── solution/
├── flashcards/                 # Anki-compatible flashcards
│   ├── deck.txt
│   └── import-instructions.md
├── scripts/                    # Utility scripts
│   ├── pomodoro.sh
│   ├── check-progress.sh
│   └── reset-cluster.sh
└── resources/                  # Additional materials
    ├── diagrams/
    ├── videos.md
    └── external-links.md
```

## 🤝 Contributing

Found an issue or want to improve a lab? Contributions welcome!

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/improved-lab`)
3. Commit changes (`git commit -am 'Improve Hour 5 lab'`)
4. Push to branch (`git push origin feature/improved-lab`)
5. Open a Pull Request

## 📜 License

MIT License - See [LICENSE](LICENSE) for details

## 🙏 Acknowledgments

- Official Kubernetes documentation
- CNCF Kubernetes Networking SIG
- Calico, Cilium, and Flannel communities
- NetworkPolicy recipes by [@ahmetb](https://github.com/ahmetb)

## 🆘 Support

- **Issues:** GitHub Issues for bugs/questions
- **Discussions:** GitHub Discussions for general help
- **Community:** Join `#kubernetes-networking` on Kubernetes Slack

## 🗺️ Learning Path

```
Prerequisites → Hours 1-4 (Fundamentals) → Hours 5-8 (Services & Policies)
     ↓
Hour 9 (Review) → Hours 10-12 (Deep Dive) → Hours 13-16 (Advanced)
     ↓
Hours 17-20 (Production) → Hours 21-23 (Troubleshooting & Review)
     ↓
Hour 24 (Final Assessment) → Mastery! 🎉
```

---

**Ready to start?** Run `./setup.sh` and begin with [Hour 1](hour-01/)!

**⭐ If this helps you, please star the repository!**
