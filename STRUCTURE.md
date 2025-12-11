# Repository Structure

```
k8s-networking-24h/
│
├── README.md                       # Main course overview
├── QUICKSTART.md                   # 5-minute getting started guide
├── CHEATSHEET.md                   # One-page command reference
├── LICENSE                         # MIT License
├── CONTRIBUTING.md                 # Contribution guidelines
├── .gitignore                      # Git ignore rules
│
├── setup.sh                        # One-command setup (kind + kubectl)
├── COMPRESSED-12H.md               # 12-hour priority track
├── COMPRESSED-8H.md                # 8-hour critical track (to be created)
├── STUDY-SCHEDULE.md               # Spaced repetition schedule (to be created)
│
├── hour-01/                        # ✅ COMPLETE
│   ├── README.md                   # Hour 1: Pod Network Fundamentals
│   ├── lab.sh                      # Automated lab setup
│   ├── manifests/
│   └── scripts/
│
├── hour-02/ through hour-06/       # Templates created (to be filled)
│
├── hour-07/                        # ✅ COMPLETE
│   ├── README.md                   # Hour 7: NetworkPolicy Basics
│   ├── lab.sh                      # Automated lab setup
│   ├── manifests/
│   │   ├── 01-default-deny-backend.yaml
│   │   ├── 02-allow-frontend-to-backend.yaml
│   │   ├── 03-allow-dns.yaml
│   │   └── 04-complete-policy-set.yaml
│   └── scripts/
│
├── hour-08/ through hour-24/       # Templates created (to be filled)
│
├── final-assessment/               # Hour 24 comprehensive exam
│   ├── README.md                   # Exam instructions & rubric
│   ├── scenario.md                 # Detailed requirements (to be created)
│   ├── manifests/
│   └── solution/                   # Reference implementation (to be created)
│
├── flashcards/                     # Spaced repetition
│   ├── deck.txt                    # 20+ flashcards in importable format
│   └── import-instructions.md      # How to use with Anki/Quizlet
│
├── scripts/                        # Utility scripts
│   ├── pomodoro.sh                 # 25-minute study timer
│   ├── check-progress.sh           # Track learning progress
│   └── reset-cluster.sh            # Clean slate reset
│
└── resources/                      # Additional materials (to be added)
    ├── diagrams/                   # Network flow visualizations
    ├── videos.md                   # Curated video links
    └── external-links.md           # Useful references
```

## Status Legend

- ✅ **COMPLETE:** Full content with labs, manifests, and assessments
- 📝 **TEMPLATE:** Structure created, needs content expansion
- ❌ **MISSING:** Placeholder, to be created

## Completion Status

| Hour | Status | Description |
|------|--------|-------------|
| 01 | ✅ | Pod Network Fundamentals (complete) |
| 02-06 | 📝 | CNI, Services, DNS, Ingress (templates) |
| 07 | ✅ | NetworkPolicy Basics (complete) |
| 08-24 | 📝 | Advanced topics (templates) |

## Contributing Priority

To complete this repository, the following need expansion:

1. **Hours 2-6:** CNI deep dive, Services, DNS, Ingress labs
2. **Hours 8-12:** Advanced NetworkPolicy, debugging, CNI internals
3. **Hours 13-20:** Service mesh, performance, security, eBPF
4. **Hours 21-23:** Case studies, production patterns, review
5. **Hour 24 solution:** Reference implementation for final exam
6. **Diagrams:** Visual aids throughout
7. **COMPRESSED-8H.md:** 8-hour critical path document

See [CONTRIBUTING.md](CONTRIBUTING.md) for guidelines.
