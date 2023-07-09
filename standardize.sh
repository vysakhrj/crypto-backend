#!/bin/bash

#neoito standardisation setup script

# description
# this scripts add mandatory standardizing practices to your project
# standardization documentation : https://neoito-engineering.notion.site/Standardizing-commit-messages-PR-issues-etc-everything-git-related-66b8c946687d4b19b6d168c15885db36


# steps 
# run the script
# add release definition to package.json

REPO=""
FILENAME=""
PS3='select you repository : '
options=("gitlab" "github" "quit")
select opt in "${options[@]}"
do
    case $opt in
        "gitlab")
            REPO=$opt
            break;
            ;;
        "github")
            REPO=$opt
            break;
            ;;
        "quit")
            exit;
            ;;
        *) echo "invalid option $REPLY"; exit;;
    esac
done


echo installing
npx husky install

if [ ! -f package.json ]; then
    echo "npm not initialised !\n"
    echo "Initialising NPM !"
    npm init
    echo "node_modules" > .gitignore
    echo "NPM INITIALIZED" 
fi

echo "Installing commitlint" 
npm install --save-dev @commitlint/{config-conventional,cli}
echo "adding commitlint hook to husky" 
npx husky add .husky/commit-msg 'npx --no-install commitlint --edit "$1"'
touch .commitlintrc.json
cat > .commitlintrc.json <<EOF
 {"extends" : ["@commitlint/config-conventional"]}
EOF
echo "commitlint setup completed"

npm i --save-dev standard-version

echo ">>>>>>>>>>>"
echo "ADD release:standard-version to package.json scripts section"
echo ">>>>>>>>>>>"

echo "creating templates"
mkdir .$REPO
cd .$REPO
if [ "$REPO" == "gitlab" ]; then
   mkdir merge_request_templates
   cd merge_request_templates
   touch default_merge_request.md
   FILENAME="default_merge_request.md"
else
   touch pull_request.md
   FILENAME="pull_request.md"
fi

cat > ${FILENAME} <<EOF
 # Description

 Please include a summary of the changes and issues that are fixed.

 # Dependencies

 please note down the dependencies that use in this code change.

 For example 
 * react-native : 1.02

 # Native Dependencies

 please note down the native dependencies that use in this code change. Which can have issues with code push

 For example 
 * react-native : 1.02

 # checklist

 - [ ] used convection commits
EOF
echo "merge request template created"

if [ "$REPO" == "github" ]; then
  exit
fi

cd ..
echo "creating issue_template"
mkdir issue_templates
cd issue_templates
touch bug_report.md
cat > bug_report.md <<EOF
 # name

 Keep it brief and use correct terms

 # Description

 Give a brief description of how the bug occurred.

 # Environment

 Tell us about what env used like qa, dev, prod

 # device

 Tell us about the device used to check like web, android, ios

 # logs

 If there are any logs, paste them.

 # Steps to reproduce

 steps to reproduce the issues

 # Expected

 Please explain the expected output

 # Actual

 Please explain the actual output
EOF
cd ..
cd ..
echo "SETUP COMPLETED"


# Author : Arun A