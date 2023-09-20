#!/bin/sh

## Do not fixup if staged files contains composer.lock or package-lock.json
if [ -n "$(git diff --cached --name-only | grep -E 'composer.json|package.json')" ]
then
	echo 'Packages file are staged, fixup is not allowed.'
	exit 1
fi

#### Goto repository root
cd "$(git rev-parse --show-toplevel)"

#### CONFIGURE REPO
pwd

#### INTEGRATE MODIFICATIONS
echo 'Update repo...'
git fetch --progress --prune --recurse-submodules=no origin

#### CHECK IF FIXUP COMMIT EXISTS
echo 'Check if fixup commit exists...'
if [ $(git log -1 --pretty=%B | grep -c 'fixup!') -eq 0 ]
then

	#### LOOK FOR COMMIT TO FIXUP IF NOT GIVEN AS PARAMETER
	if [ -z "$1" ]
	then
		#### GET COMMIT TO FIXUP
		echo 'Get commit to fixup...'
		git log --oneline -n10
		read -p 'What commit to fix? ' sha
	else
		#### USE COMMIT TO FIXUP FROM PARAMETER
		sha=$1
		echo 'Fixup commit given:' $sha
	fi

	#### CREATE FIXUP COMMIT
	echo 'Create fixup commit...'
	git commit --fixup $sha
else
  	#### GET FIXUP COMMIT
	echo 'Fixup commit already exists...'
 	cmt=$(git log -n1 --pretty=%B | cut -d' ' -f2-)
  	sha=$(git log -n50 --pretty='%h %B' | grep -Ev 'fixup!' | grep "$cmt" | cut -d' ' -f1)

	if [ -n "$sha" ]
	then
		#### FIXUP COMMIT FOUND
		echo 'Original commit found:' $sha $cmt
	else
		#### FIXUP COMMIT NOT FOUND
		echo 'Original commit not found...'
		git log --oneline -n10
		read -p 'What commit to fix? ' sha
	fi

	#### DISPLAY FIXUP COMMIT
	echo 'Original commit to fixup:' $sha $cmt
fi

#### IF IN REBASE
if [ -d .git/rebase-merge ]
then
	#### CONTINUE REBASE
	echo 'Rebase in progress...'
	git rebase --continue
else
	#### START REBASE
	echo 'Rebase from ' $sha
	git rebase --autosquash $sha~ --no-verify --autostash
fi

#### BACK
cd - >/dev/null
