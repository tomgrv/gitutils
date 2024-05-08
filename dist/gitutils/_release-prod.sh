#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### GET BUMP VERSION
GBV=$(~/.dotnet/tools/dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch)

#### CHECKOUT RELEASE BRANCH
git checkout release/$(cat .git/RELEASE)

#### UPDATE VERSION & CHANGELOG & FINISH RELEASE
npx commit-and-tag-version --skip.tag --no-verify --release-as $GBV && git flow release finish $(cat .git/RELEASE) --tagname $GBV --message $GBV --push && rm .git/RELEASE

#### BACK
cd - >/dev/null
