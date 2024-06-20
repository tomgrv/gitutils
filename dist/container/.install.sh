#!/bin/bash

echo "Configuring husky for this repo..." | npx chalk-cli --stdin blue

### Go to the module root
cd "$(git rev-parse --show-toplevel)" >/dev/null

### Alias to module root
module=$(dirname $(readlink -f $0))

### Make sure all files in folder are executable
for file in ./.devcontainer/*.sh; do
    chmod 755 "$file"
done

### Eventually remove from git
git add .devcontainer 2>/dev/null && echo ".devcontainer folder now tracked" | npx chalk-cli --stdin yellow

### Ask to restart in container if this is not already the case
git diff --name-only HEAD@{1} HEAD | grep -q ".devcontainer/devcontainer.json" && echo "Please rebuild container" | npx chalk-cli --stdin red
git diff --name-only | grep -q ".devcontainer/devcontainer.json" && echo "Please rebuild container" | npx chalk-cli --stdin yellow
