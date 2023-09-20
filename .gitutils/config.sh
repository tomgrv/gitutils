#!/bin/sh

#### DETECT OS
unameOut="$(uname -s)"

#### MAP OS TO MACHINE
case "${unameOut}" in
    Linux*)     machine=Linux;;
    Darwin*)    machine=Mac;;
    CYGWIN*)    machine=Cygwin;;
    MINGW*)     machine=MinGw;;
    *)          machine="UNKNOWN:${unameOut}"
esac

#### CONFIGURE REPO FOR MAC
if [ $machine == "Mac" ]
then
    echo 'Configuring git for Mac...'
    
fi

#### CONFIGURE REPO FOR LINUX
if [ $machine == "Linux" ]
then
    echo 'Configuring git for Linux...'
fi

#### CONFIGURE REPO FOR MinGw/WINDOWS
if [ $machine == "MinGw" ]
then
    echo 'Configuring git for MinGw...'
    git config core.filemode false
    git config --global credential.helper wincred
fi

echo "Configuring git globally for all platforms..."
git config --global core.autocrlf input
git config --global alias.utils "!sh -c \"$(readlink -f $0) $*\" - "
git config --global alias.amend '!sh -c "git diff-index --cached --quiet HEAD || git commit --no-verify --amend -C HEAD" - '
git config --global alias.undo '!sh -c "git reset --soft HEAD^ --" - '
git config --global alias.clean '!sh -c "git reset --hard HEAD --" - '
git config --global alias.renameTag  '!sh -c "set -e;git tag $2 $1; git tag -d $1;git push origin :refs/tags/$1;git push --tags" - '
git config --global alias.initFrom  '!sh -c "git clone --origin template --branch master --depth 1 -- $1 $2 && cd $2 && git branch -m master template && git checkout -b master && git checkout -b develop" - '
git config --global alias.pretty  '!sh -c "git log --oneline -n$1" - '
git config --global alias.isChanged  '!sh -c "git diff --name-only HEAD@{1} HEAD | grep \"^$1\" && (echo true; exit 0) || (echo false; exit 1)" - '
git config --global alias.hibernate  '!sh -c "git stash save --include-untracked  --keep-index; git clean --force -d -x -e \".env*\"; git stash apply --index; git stash drop" - '
git config --global alias.isRebase  '!sh -c "git rev-parse --git-dir | grep -q \"rebase-merge\" || git rev-parse --git-dir | grep -q \"rebase-apply\"" - '

echo "Adding script aliases..."
for f in $(dirname "$0")/_*.sh
do
    alias=$(basename $f .sh)
    if [ "$1" == "global" ]
    then
        echo "Adding global alias for $(readlink -f $f)..."
        git config --global alias.${alias#_} "!sh -c \"$(readlink -f $f)\" - "
    else
        echo "Adding alias for $(readlink -f $f)..."
        git config alias.${alias#_} "!sh -c \"$(readlink -f $f)\" - "
    fi
done


echo "Configuring git for this repo..."

echo "Defining .gitattributes..."
cat <<-EOF > .gitattributes
    * text=auto eol=lf
    *.{cmd,[cC][mM][dD]} text eol=crlf
    *.{bat,[bB][aA][tT]} text eol=crlf
    *.css linguist-vendored
    *.scss linguist-vendored
    *.js linguist-vendored
    CHANGELOG.md export-ignore
EOF


echo "Done."