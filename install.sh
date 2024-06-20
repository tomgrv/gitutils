#!/bin/sh

### Go to root
cd $(git rev-parse --show-toplevel) >/dev/null

### Stash all changes including untracked files
stash=$(git stash -u && echo true)

### Alias to current module
module=$(dirname $(readlink -f $0))

### Merge all files from stub folder to root with git merge-file
echo "Merging stub files" | npx chalk-cli --stdin blue
for file in $(find $module/stub -type f); do

    ### Get middle part of the path
    folder=$(dirname ${file#$module/stub/})

    ### Create folder if not exists
    mkdir -p $folder

    ### Merge file
    echo "Merge $folder/$(basename $file)" | npx chalk-cli --stdin yellow
    git merge-file -p $file $folder/$(basename $file) ${folder#./}/$(basename $file) >$folder/$(basename $file)
done

### find all file with a trailing slash outside dist folder, make sure they are added to .gitignore and remove the trailing slash
echo "Add files to .gitignore" | npx chalk-cli --stdin blue
for file in $(find . -type f -name "*#" -not -path "./stub/*" -not -path "./node_modules/*" -not -path "./vendors/*"); do

    echo "Add $file to .gitignore" | npx chalk-cli --stdin yellow

    ### Remove trailing # and leading ./
    clean=${file%#}
    clean=${clean#./}

    ### Add to .gitignore if not already there
    grep -qxF $clean .gitignore || echo $clean >>.gitignore

    ### Rename file
    mv $file ${file%#}
done

### Ask to restart in container if this is not already the case
if [ "$CODESPACES" != "true" ] && [ "$REMOTE_CONTAINERS" != "true" ]; then
    echo "You are not in a container" | npx chalk-cli --stdin red

    ### check if jq is installed and install it if not
    echo "Check jq & Install if this is not the case" | npx chalk-cli --stdin blue
    if ! command -v jq >/dev/null 2>&1; then

        OS="$(uname)"

        case ${OS%%-*} in
        "Darwin")
            brew install jq
            ;;
        "Linux")
            sudo apt-get install jq
            ;;
        "MINGW64_NT")
            curl -L -o /usr/bin/jq.exe https://github.com/stedolan/jq/releases/latest/download/jq-win64.exe
            ;;
        *)
            echo "Unknown operating system: ${OS%%-*}"
            exit 1
            ;;
        esac
    fi
fi

### Call the install.sh script in all subfloder of the dist folder
for file in $(find $module/dist -type f -name ".install.sh"); do

    ### Get middle part of the path
    folder=$(dirname ${file#$module/dist/})

    ### Add folder to .gitignore if not already there
    echo "Add .$folder to .gitignore" | npx chalk-cli --stdin yellow

    ### Add folder to .gitignore if not already there
    grep -qxF /.$folder .gitignore || echo /.$folder >>.gitignore

    ### Run the install.sh script
    echo "Running $file" | npx chalk-cli --stdin blue
    bash $file
done

### Stage non withespace changes
git ls-files --others --exclude-standard | xargs -I {} bash -c 'if [ -s "{}" ]; then git add "{}"; fi'
git diff -w --no-color | git apply --cached --ignore-whitespace
git checkout -- . && git reset && git add .

### Unstash changes
test -n "$stash" && git stash apply && git stash drop
