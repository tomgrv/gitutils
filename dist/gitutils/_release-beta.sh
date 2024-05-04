#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### GET BUMP VERSION
GBV=$(git bump-version | tee .git/RELEASE)

#### START RELEASE
git flow release start $GBV && npx commit-and-tag-version --skip.tag --no-verify

#### BACK
cd - >/dev/null
