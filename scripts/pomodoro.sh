#!/bin/bash

# Simple Pomodoro timer for 25-minute study sessions

echo "🍅 Pomodoro Timer"
echo "================"
echo ""
echo "Study session: 25 minutes"
echo "Press Ctrl+C to stop"
echo ""

# 25 minutes = 1500 seconds
DURATION=1500
ELAPSED=0

while [ $ELAPSED -lt $DURATION ]; do
    REMAINING=$((DURATION - ELAPSED))
    MINUTES=$((REMAINING / 60))
    SECONDS=$((REMAINING % 60))
    
    printf "\rTime remaining: %02d:%02d" $MINUTES $SECONDS
    
    sleep 1
    ELAPSED=$((ELAPSED + 1))
done

echo ""
echo ""
echo "⏰ Time's up! Take a 5-minute break."
echo ""

# Optional: Play sound (if afplay/aplay available)
if command -v afplay &> /dev/null; then
    afplay /System/Library/Sounds/Glass.aiff 2>/dev/null || true
elif command -v aplay &> /dev/null; then
    (speaker-test -t sine -f 1000 -l 1 &) 2>/dev/null || true
    sleep 0.5
    killall speaker-test 2>/dev/null || true
fi
