#!/bin/bash

# 1. Compile the Java script
echo "Compiling HelloWorld.java..."
javac HelloWorld.java

# 2. Run the Java script
echo "Running HelloWorld..."
java HelloWorld

# 3. Configure Git (Optional if already configured globally on Jenkins agent)
# git config --global user.email "your-email@example.com"
# git config --global user.name "Jenkins Job"

# 4. Stage changes (e.g., the activity.log file updated by Java)
echo "Staging changes..."
git add .

# 5. Commit changes
# Use || true to prevent job failure if there are no changes to commit
echo "Commiting changes..."
git commit -m "Jenkins Auto-update: $(date)" || echo "No changes to commit"

# 6. Push to GitHub
# Note: This assumes Jenkins has credentials configured (SSH or Credential Helper)
echo "Pushing to GitHub..."
git push origin HEAD:main
