#!/bin/bash

# Set the repository path and file to track
REPO_PATH="/home/psct/cta-psct.physics.ucla.edu"
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

# Set the size threshold in MB
THRESHOLD_MB=1024  # Replace 100 with the desired size limit in MB

# Get the size of the .git directory in MB
REPO_SIZE=$(du -sm . | awk '{print $1}')

# Check if the repository size exceeds the threshold
if (( REPO_SIZE > THRESHOLD_MB )); then
    echo "Repository size (${REPO_SIZE} MB) exceeds ${THRESHOLD_MB} MB."
    # Execute your custom script or command here
    ./git_clean.sh
else
    echo "Repository size is within limits (${REPO_SIZE} MB)."
fi  
