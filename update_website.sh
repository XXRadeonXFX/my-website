#!/bin/bash

# Set your GitHub repo and local/web paths
REPO_URL="https://github.com/XXRadeonXFX/my-website.git"
REPO_DIR="/home/ubuntu/my-website/html"
WEBSITE_DIR="/var/www/my-website"  

# Pull latest changes
cd "$REPO_DIR" || exit
git pull origin main

# Ensure destination directory exists
sudo mkdir -p "$WEBSITE_DIR"

# Sync files with correct permissions
sudo rsync -av --delete "$REPO_DIR/" "$WEBSITE_DIR/"

# Restart Nginx
sudo systemctl restart nginx

echo "Website updated successfully"
