#!/bin/bash

# Make script exit immediately if any command fails
set -e

echo "=== LingoLock Git Initializer ==="

# Initialize git repository
if [ ! -d ".git" ]; then
    git init
    echo "Initialized empty Git repository."
else
    echo "Git repository already initialized."
fi

# Create a standard .gitignore file
cat << 'EOF' > .gitignore
# Xcode
build/
*.xcodeproj
*.xcworkspace
DerivedData/
*.moved-aside
*.xcuserstate
.orange/

# Dependency directories
node_modules/
jspm_packages/
.pnp
.pnp.js

# Testing
coverage/

# Production
build-prod/

# Logs
logs
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# OS Files
.DS_Store
Thumbs.db

# Environment variables
.env
.env.local
.env.development.local
.env.test.local
.env.production.local
EOF
echo "Created .gitignore"

# Add all files to Git
git add .

# Make initial commit
git commit -m "Initial commit: LingoLock App and Widgets with GitHub Actions Build"

echo ""
echo "=========================================================="
echo "SUCCESS: Repository initialized and committed locally!"
echo "=========================================================="
echo "To push this to your GitHub account and build the app:"
echo "1. Go to https://github.com and create a new PUBLIC repository named 'lingolock'"
echo "2. Run the following commands in this terminal (replace YOUR-USERNAME):"
echo ""
echo "   git remote add origin https://github.com/YOUR-USERNAME/lingolock.git"
echo "   git branch -M main"
echo "   git push -u origin main"
echo ""
echo "Once pushed, go to the 'Actions' tab on your GitHub repository page"
echo "to download the compiled iOS app installer!"
echo "=========================================================="
