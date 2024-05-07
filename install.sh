#!/bin/sh

echo "Copying stub files" | npx chalk-cli --stdin blue

# Go to root
cd $(npm root)/..

# Copy all files from dist to root
sudo cp -rupa ./stub/. .

# find all file with a trailing slash outside dist folder, make sure they are added to .gitignore and remove the trailing slash
echo "Add files to .gitignore" | npx chalk-cli --stdin blue
for file in $(find . -type f -name "*#" -not -path "./stub/*"); do

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
for file in $(find ./dist -type f -name "install.sh"); do

    ### Get middle part of the path
    folder=$(dirname ${file#./dist/})

    ### Add folder to .gitignore if not already there
    echo "Add .$folder to .gitignore" | npx chalk-cli --stdin yellow

    ### Add folder to .gitignore if not already there
    grep -qxF /.$folder .gitignore || echo /.$folder >>.gitignore

    ### Run the install.sh script
    echo "Running $file" | npx chalk-cli --stdin blue
    bash $file
done
