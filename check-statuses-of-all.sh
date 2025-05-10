#!/bin/bash

echo "=== Main Repository ==="
echo "Path: $(pwd)"

git fetch > /dev/null 2>&1

# Show unstaged changes in main repo
main_unstaged=$(git status --porcelain | grep "^ M" || true)
if [ -n "$main_unstaged" ]; then
  echo "Unstaged changes:"
  echo "$main_unstaged"
else
  echo "Unstaged changes: None"
fi

# Show branch status of main repo
main_branch_status=$(git status -sb | head -n 1)
echo "Branch status: $main_branch_status"
echo "----"

echo
echo "=== Submodules ==="

git submodule foreach --quiet '
  echo "Name: $name"
  echo "Path: $path"

  git fetch > /dev/null 2>&1

  # Show unstaged changes
  unstaged=$(git status --porcelain | grep "^ M" || true)
  if [ -n "$unstaged" ]; then
    echo "Unstaged changes:"
    echo "$unstaged"
  else
    echo "Unstaged changes: None"
  fi

  # Show branch status
  branch_status=$(git status -sb | head -n 1)
  echo "Branch status: $branch_status"

  echo "----"
'
