#!/bin/bash

set -e

commit_if_needed() {
  repo_path=$1
  cd "$repo_path"

  # Check for changes
  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "[$repo_path] Changes detected, committing..."
    git add .
    git commit -m "Auto-commit: push-all.sh"
  else
    echo "[$repo_path] No changes to commit."
  fi

  # Check if branch is ahead
  git fetch > /dev/null 2>&1
  branch_status=$(git status -sb | head -n 1)

  if [[ "$branch_status" == *"[ahead "* ]]; then
    echo "[$repo_path] Branch is ahead, pushing..."
    git push
  else
    echo "[$repo_path] Nothing to push."
  fi

  cd - > /dev/null
}

echo "=== Main Repository ==="
commit_if_needed "$(pwd)"

echo
echo "=== Submodules ==="
git submodule foreach --quiet '
  branch=$(git rev-parse --abbrev-ref HEAD)
  if [ "$branch" != "main" ]; then
    echo "[$name] Skipping (not on main branch: $branch)"
  else
    echo "[$name] Processing..."
    '"$(declare -f commit_if_needed)"'
    commit_if_needed "$toplevel/$path"
  fi
'
