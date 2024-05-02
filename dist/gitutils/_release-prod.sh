#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### GET BUMP VERSION
GBV=$(git bump-version)

#### FINISH RELEASE
git flow release finish $(cat .git/RELEASE) --tagname $GBV --message $GBV --push && rm .git/RELEASE

#### BACK
cd - >/dev/null
