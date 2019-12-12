#!/usr/bin/env bash

# https://gohugo.io/hosting-and-deployment/hosting-on-github/

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# If a command fails then the deploy stops
set -e

printf "\033[0;32mDeploying updates to GitHub...\033[0m\n"

cd $SCRIPTPATH/blog

rm -rf $SCRIPTPATH/blog/public

# Build the project.
hugo # if using a theme, replace with `hugo -t <YOURTHEME>`

# Go To Public folder
cd public

# Add changes to git.
# git add .

# Commit changes.
msg="rebuilding site $(date)"
if [ -n "$*" ]; then
	msg="$*"
fi
# git commit -m "$msg"

# Push source and build repos.
# git push origin master