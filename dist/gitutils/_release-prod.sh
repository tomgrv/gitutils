#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### CHECK IF ON A HOTFIX BRANCH, EXTRACT BRANCH NAME
if [ -n "$(git branch --list hotfix/*)" ]; then
    flow=hotfix
    name=$(git branch --list hotfix/* | sed 's/.*hotfix\///')
    npx chalk-cli -t "{green ✔} Hotfix branch found: {yellow $name}"
fi

#### CHECK IF ON A RELEASE BRANCH, EXTRACT BRANCH NAME
if [ -n "$(git branch --list release/*)" ]; then
    flow=release
    name=$(git branch --list release/* | sed 's/.*release\///')
    npx chalk-cli -t "{green ✔} Release branch found: {blue $name}"
fi

#### CHECK IF A FLOW BRANCH IS FOUND
if [ -z "$flow" ] && [ -f .git/RELEASE ]; then
    flow=release
    name=$(cat .git/RELEASE)

    npx chalk-cli -t "{green ✔} Release branch found: {blue $name}"
    git checkout $flow/$name
fi

#### EXIT IF NO FLOW BRANCH IS FOUND
if [ -z "$flow" ] || [ -z "$name" ]; then
    npx chalk-cli -t "{red ✘} No flow branch found"
    exit 1
fi

#### GET BUMP VERSION
GBV=$(gitversion -config .gitversion -showvariable MajorMinorPatch)

#### UPDATE VERSION & CHANGELOG & FINISH RELEASE
npx commit-and-tag-version --skip.tag --no-verify --release-as $GBV && git flow $flow finish $name --tagname $GBV --message $GBV --push && rm -f .git/RELEASE

#### BACK
cd - >/dev/null
