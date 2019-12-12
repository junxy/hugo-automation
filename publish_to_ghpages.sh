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

printf "${YELLOW}Deleting old publication${NOCOLOR}\n"
rm -rf public
mkdir public
git worktree prune
rm -rf .git/worktrees/public/

printf "${YELLOW}Checking out gh-pages branch into public${NOCOLOR}\n"
git worktree add -B gh-pages public origin/gh-pages  # upstream -> origin

printf "${YELLOW}Removing existing files${NOCOLOR}\n"
rm -rf public/*

printf "${GREEN}Generating site${NOCOLOR}\n"
hugo

# def 
remote_repo='origin'
git_msg="Publishing to gh-pages $(date) (publish_to_ghpages.sh) "

#env vars -> https://help.github.com/en/actions/automating-your-workflow-with-github-actions/using-environment-variables
if [ "$GITHUB_ACTIONS" = "true" ]; then
    git_msg="${git_msg} - Powered By GitHub Actions"
    #ref: https://github.com/ad-m/github-push-action/blob/master/start.sh 
    remote_repo="https://${GITHUB_ACTOR}:${passowrd}@github.com/${GITHUB_REPOSITORY}.git"

    [ ! `git config --get user.nam` ] && git config --global user.name "${GITHUB_ACTOR}"
    [ ! `git config --get user.nam` ] && git config --global user.email "${GITHUB_ACTOR}@users.noreply.github.com"
fi

printf "${GREEN}Updating gh-pages branch${NOCOLOR}\n"
cd public && git add --all && git commit -m "$git_msg"

#echo "Pushing to github"
#git push --all
# git push origin gh-pages
git push "${remote_repo}" gh-pages

printf "${GREEN}Done${NOCOLOR}\n"