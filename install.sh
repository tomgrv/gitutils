#!/bin/sh

echo "Copying stub files" | npx chalk-cli --stdin blue

### Go to root
cd $(git rev-parse --show-toplevel) >/dev/null

### Alias to current module
module=$(dirname $(readlink -f $0))

### Copy all files from dist to root
sudo cp -rpa $module/stub/. .

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

### Call the install.sh script in all subfloder of the dist folder
for file in $(find $module/dist -type f -name "install.sh"); do

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
