#!/bin/bash

# Check learning progress through the 24 hours

echo "📊 Learning Progress Tracker"
echo "============================"
echo ""

TOTAL_HOURS=24
COMPLETED=0

for i in $(seq -w 1 24); do
    hour_dir="hour-$i"
    if [ -d "$hour_dir" ]; then
        # Check if lab.sh has been run (look for common pod names)
        case "$i" in
            "01")
                if kubectl get pod net-test-1 &>/dev/null; then
                    COMPLETED=$((COMPLETED + 1))
                    echo "✅ Hour $i: Completed"
                else
                    echo "⬜ Hour $i: Not started"
                fi
                ;;
            "07")
                if kubectl get networkpolicy -n backend &>/dev/null; then
                    COMPLETED=$((COMPLETED + 1))
                    echo "✅ Hour $i: Completed"
                else
                    echo "⬜ Hour $i: Not started"
                fi
                ;;
            *)
                echo "⬜ Hour $i: Template (to be completed)"
                ;;
        esac
    fi
done

echo ""
echo "Progress: $COMPLETED / $TOTAL_HOURS hours completed"
PERCENT=$((COMPLETED * 100 / TOTAL_HOURS))
echo "Completion: $PERCENT%"
echo ""

if [ $COMPLETED -eq 0 ]; then
    echo "💡 Tip: Start with hour-01/ to begin your learning journey!"
elif [ $COMPLETED -lt 6 ]; then
    echo "🚀 Good start! Keep going with the fundamentals."
elif [ $COMPLETED -lt 12 ]; then
    echo "💪 Great progress! You're halfway through."
elif [ $COMPLETED -lt 24 ]; then
    echo "🔥 Excellent work! Almost there!"
else
    echo "🎉 Congratulations! You've completed the entire course!"
    echo "📝 Take the final assessment to validate your skills."
fi
