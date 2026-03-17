#!/bin/bash
# Marketing Automation Cron Script for ZeroClaw
# Usage: ./marketing-cron.sh <task>
# Tasks: bookbub, cover-review, email, storyorigin, relaunch, review, monthly

cd "$(dirname "$0")" || exit  # Change to script directory

TASK=$1
DATE=$(date +%Y%m%d)
FILENAME="output/${TASK}-${DATE}.md"

if [ -z "$TASK" ]; then
  echo "Usage: $0 <task>"
  echo "Available tasks: bookbub, cover-review, email, storyorigin, relaunch, review, monthly"
  exit 1
fi

# Ensure output directory exists
mkdir -p output

case $TASK in
  "bookbub")
    echo "# BookBub Day $(date +%d) Analysis" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "SEO Specialist + USER.md/STYLE.md: Analyze uploads/bookbub-$(date +%Y%m%d).csv. CTR>0.5%? CPC<\$1.25? Downloads vs targets. Recs: scale/pause/optimize authors (Wight/Rowe/etc.). Save detailed analysis to output/bookbub-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "cover-review")
    echo "# Cover Review - ZAHANARA" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Brand Guardian: MiBlart ZAHANARA concept checklist (Afrocentric dark cult, Anansi webs, comps: Rage/Poppy). Blurb refresh + relaunch plan. Save to output/cover-review-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "email")
    echo "# Weekly Email Campaign" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Content Creator: Weekly nurture for ~50 subs. Lore hook (Anansi curse), BookBub spike teaser, 99¢ prequel. Pro plan → casual copy. Save to output/email-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "storyorigin")
    echo "# StoryOrigin Promo Recommendations" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Social Strategist: 2–3 group promos (dark/prog fantasy, African myth). Costs \$0–50, ROI est for list growth. Save to output/storyorigin-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "relaunch")
    echo "# Mini-Relaunch Plan" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Orchestrator: Apr 1–14 mini‑relaunch. New cover upload, \$0.99 ZAHANARA pulse 5 days, Amazon ad draft (\$10/day), newsletter + StoryOrigin. Save complete plan to output/relaunch-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "review")
    echo "# Weekly Performance Review" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Analytics Reporter: Weekly from uploads/ CSVs. Prequel dls (20+ goal), ZAHANARA sales (5–15), list (50+). Apr 10: KDP decision tree. Save to output/review-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  "monthly")
    echo "# Monthly Executive Summary" > "$FILENAME"
    echo "" >> "$FILENAME"
    docker exec zeroclaw-marketing zeroclaw agent -m \
      "Executive Summary: Mar metrics (ACoS, budget \$380, list growth). Kill/scale: BookBub/Amazon. Cover impact? Save to output/monthly-$(date +%Y%m%d).md" \
      >> "$FILENAME" 2>&1
    ;;
  *)
    echo "Unknown task: $TASK"
    echo "Available tasks: bookbub, cover-review, email, storyorigin, relaunch, review, monthly"
    exit 1
    ;;
esac

echo "✓ Task completed: $TASK"
echo "✓ Output: $FILENAME ready for review."
