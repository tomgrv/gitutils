#!/bin/sh

#### Goto repository root
cd "$(git rev-parse --show-toplevel)" >/dev/null

#### GET BUMP VERSION
GBV=$(~/.dotnet/tools/dotnet-gitversion -config .gitversion -showvariable MajorMinorPatch | tee .git/RELEASE)

#### START RELEASE
git flow release start $GBV

#### BACK
cd - >/dev/null
