#!/bin/bash

# Set the repository path and file to track
REPO_PATH="/home/pi/cta-psct.physics.ucla.edu"
FILE_PATH="images/webcam.jpg"
BRANCH="main" # Change this to your desired branch if necessary

log_message() {
  echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Navigate to the repository path
cd "$REPO_PATH" || { log_message  "Error: Repository path not found"; exit 1; }

#Create a new orphan branch (without history)
git checkout --orphan temp_branch

sleep 2
git add .
if [ $? -ne 0 ]; then
  log_message "Error: Failed to add file to staging area"
  rm -f .git/index.lock
  exit 1
fi

sleep 5

git commit -m "Clean slate"
if [ $? -ne 0 ]; then
  log_message "Error: Failed to commit changes"
  rm -f .git/index.lock
  exit 1
fi

sleep 5

#Delete the old branch 
git branch -D  "$BRANCH"

sleep 5
# Rename the orphan branch to match the original branch name:
git branch -m  "$BRANCH"
sleep 2
git push origin "$BRANCH" --force
if [ $? -ne 0 ]; then
  log_message "Error: Failed to push changes to remote repository"
  rm -f .git/index.lock
  exit 1
fi

log_message "File successfully added, committed, and pushed to the repository"
  
