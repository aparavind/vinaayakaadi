#!/bin/bash

# Fetch all remote branches from origin to make sure your local tracking is up to date
echo "🔄 Fetching latest branches from origin..."
git fetch origin

# Get a list of all remote branches, excluding 'main', 'master', and 'HEAD'
echo "📋 Finding branches to submit..."
BRANCHES=$(git branch -r | grep 'origin/' | grep -vE 'HEAD|origin/main|origin/master' | sed 's/^[[:space:]]*origin\///')

if [ -z "$BRANCHES" ]; then
    echo "ℹ️ No other branches found to merge."
    exit 0
fi

# Loop through each branch and create a Pull Request
for BRANCH in $BRANCHES; do
    echo "--------------------------------------------------"
    echo "🚀 Creating PR for branch: $BRANCH"
    
    # Run the GitHub CLI command with hardcoded repositories
    gh pr create \
        --repo "aparavind/vinaayakaadi" \
        --base "main" \
        --head "parimalagh:${BRANCH}" \
        --title "Merge $BRANCH into main" \
        --body "Automated pull request to merge changes from $BRANCH into the target main branch."
        
    # Check if the command succeeded or failed
    if [ $? -eq 0 ]; then
        echo "✅ Successfully created PR for $BRANCH"
    else
        echo "⚠️  Skipped or Failed for $BRANCH (It might already exist)"
    fi
done

echo "--------------------------------------------------"
echo "🎉 Done processing all branches!"

