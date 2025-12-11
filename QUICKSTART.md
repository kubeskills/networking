# 🚀 Quick Start Guide

Get started with the Kubernetes Networking 24h course in 5 minutes.

## Prerequisites

- **Docker** installed and running
- **15 GB** free disk space
- **4 GB** RAM available
- **Mac, Linux, or WSL2** (Windows)

## Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/k8s-networking-24h.git
cd k8s-networking-24h
```

## Step 2: Run Setup

```bash
./setup.sh
```

This installs:
- kind (Kubernetes in Docker)
- kubectl
- Creates a 3-node test cluster

**Time: ~5 minutes**

## Step 3: Verify Installation

```bash
kubectl get nodes
```

Expected output:
```
NAME                   STATUS   ROLES           AGE   VERSION
netlab-control-plane   Ready    control-plane   1m    v1.28.0
netlab-worker          Ready    <none>          1m    v1.28.0
netlab-worker2         Ready    <none>          1m    v1.28.0
```

## Step 4: Start Learning!

```bash
cd hour-01/
cat README.md    # Read the hour's objectives
./lab.sh         # Run automated lab setup
```

## Alternative: Browser-Based (No Installation)

**Use Play with Kubernetes:**

1. Go to https://labs.play-with-k8s.com/
2. Create a new instance
3. Clone this repository
4. Follow hour-by-hour lessons

## Study Path Options

### Full 24-Hour Track
Complete all hours sequentially: [hour-01/](hour-01/) → [hour-24/](hour-24/)

### 12-Hour Priority Track
See [COMPRESSED-12H.md](COMPRESSED-12H.md) for accelerated path

### 8-Hour Critical Track
Absolute essentials: Hours 1, 3, 4-5, 7, 12 only

## Learning Workflow

For each hour:

1. **Read** the hour's README.md (10-15 min)
2. **Run** the lab script (./lab.sh)
3. **Practice** with provided manifests
4. **Answer** assessment questions
5. **Create** flashcards for retention
6. **Move** to next hour

## Pomodoro Timer

Use built-in timer for 25-minute study sessions:

```bash
./scripts/pomodoro.sh
```

## Check Progress

```bash
./scripts/check-progress.sh
```

## Reset Cluster

If you mess up and want to start fresh:

```bash
./scripts/reset-cluster.sh
```

## Quick Reference

- **Cheatsheet:** [CHEATSHEET.md](CHEATSHEET.md) - Print this!
- **Flashcards:** [flashcards/deck.txt](flashcards/deck.txt)
- **Final Exam:** [final-assessment/](final-assessment/)

## Getting Help

- **Issues in lab?** Check the hour's README.md for troubleshooting
- **Concept unclear?** Review CHEATSHEET.md
- **Stuck on debug?** Use `kubectl run debug --rm -it --image=nicolaka/netshoot`
- **Questions?** Open a GitHub issue

## Pro Tips

1. **Type commands** - don't copy-paste (builds muscle memory)
2. **Draw diagrams** - sketch network flows on paper
3. **Use flashcards** - create them as you learn
4. **Test yourself** - try labs without looking at solutions
5. **Take breaks** - Pomodoro technique (25 min work, 5 min break)

## Next Steps

✅ Setup complete? → Start with [Hour 1](hour-01/)

---

**Good luck on your 24-hour journey to Kubernetes networking mastery! 🎓**
