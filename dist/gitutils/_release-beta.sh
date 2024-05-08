#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### GET BUMP VERSION
GBV=$(~/.dotnet/tools/dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch | tee .git/RELEASE)

#### EXIT IF OTHER RELEASE EXISTS
if [ -n "$(git branch --list release/* | grep -v $(cat .git/RELEASE))" ]; then
    echo 'Other release exists, cannot proceed.' | npx chalk-cli --stdin --color red
    exit 1
fi

#### START RELEASE
git flow release start $GBV

#### BACK
cd - >/dev/null
