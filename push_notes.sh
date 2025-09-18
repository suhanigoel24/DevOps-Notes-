#!/bin/bash

# Go to your vault directory
cd ~/Documents/ObsidianVault

# Make sure the branch is main
git checkout main

# Pull remote changes to avoid conflicts
git pull origin main --rebase

# Add all changes
git add .

# Commit changes with a timestamp
git commit -m "Update notes: $(date '+%Y-%m-%d %H:%M:%S')"

# Push to GitHub
git push origin main


