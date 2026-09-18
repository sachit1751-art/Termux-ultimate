#!/bin/bash

MESSAGES=(
  "docs: update maintenance log"
  "refactor: minor code cleanup"
  "chore: sync tracking state"
  "fix: correct formatting output"
  "style: adjust workspace spacing"
  "test: verify utility parameters"
  "build: internal dependency sync"
  "perf: optimize background routines"
  "docs: update status metrics"
  "chore: minor repository maintenance"
  "ci: refresh pipeline triggers"
  "style: cleanup trailing whitespace"
  "refactor: restructure helper functions"
  "docs: patch typo in README"
  "chore: bump internal revision counter"
  "test: add unit check assertion"
  "perf: reduce redundant allocations"
  "fix: resolve edge case validation"
  "build: update workspace lock state"
  "chore: run routine health check"
  "style: update button hover transition effect"
  "fix: adjust mobile responsive grid layout"
  "ui: refine hero section canvas lighting"
  "style: tweak card shadow and border radius"
  "perf: lazy load heavy 3D assets"
  "ui: update navbar backdrop blur intensity"
  "fix: correct typography scale on desktop"
  "style: align footer link spacing"
  "refactor: extract reusable card component"
  "seo: update meta tags for portfolio routes"
  "ui: improve smooth scrolling behavior"
  "style: adjust dark mode contrast colors"
  "fix: resolve layout shift on image load"
  "ui: refine project preview modal animation"
  "perf: compress texture assets for webgl"
)

echo "SAFE FAST push loop starting (15s sleep)..."

while true
do
  RANDOM_INDEX=$(( RANDOM % ${#MESSAGES[@]} ))
  SELECTED_MSG="${MESSAGES[$RANDOM_INDEX]}"

  echo "Automated sync executed at $(date +%s%N)" >> activity_log.txt
  git add activity_log.txt
  
  # [skip ci] attached to every commit message -> blocks Vercel auto builds
  git commit -m "$SELECTED_MSG [skip ci]" || true
  git push origin main || true

  echo "Pushed! Sleeping 15 seconds..."
  sleep 15
done