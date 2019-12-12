#!/usr/bin/env bash

# https://gohugo.io/hosting-and-deployment/hosting-on-github/

SCRIPT=$(readlink -f $0)
SCRIPTPATH=`dirname $SCRIPT`

# https://gist.github.com/jonsuh/3c89c004888dfc7352be 
NOCOLOR='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
ORANGE='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
LIGHTGRAY='\033[0;37m'
DARKGRAY='\033[1;30m'
LIGHTRED='\033[1;31m'
LIGHTGREEN='\033[1;32m'
YELLOW='\033[1;33m'
LIGHTBLUE='\033[1;34m'
LIGHTPURPLE='\033[1;35m'
LIGHTCYAN='\033[1;36m'
WHITE='\033[1;37m'

# If a command fails then the deploy stops
set -e

cd $SCRIPTPATH/blog

if [ "`git status -s`" ]
then
    echo ""
	printf "${RED}The working directory is dirty. Please commit any pending changes.${NOCOLOR}\n"
    exit 1;
fi

printf "${GREEN}Deploying updates to GitHub...${NOCOLOR}\n"

echo "Deleting old publication"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

echo "Checking out gh-pages branch into public"
git worktree add -B gh-pages public origin/gh-pages  # upstream -> origin

echo "Removing existing files"
rm -rf public/*

echo "Generating site"
hugo

echo "Updating gh-pages branch"
cd public && git add --all && git commit -m "Publishing to gh-pages $(date) (publish_to_ghpages.sh) "

#echo "Pushing to github"
#git push --all
git push origin gh-pages