#!/bin/bash

echo "Configuring husky for this repo..." | npx chalk-cli --stdin blue

### Go to the module root
cd "$(git rev-parse --show-toplevel)" >/dev/null

### Make sure all files in .husky folder are executable
for file in .husky/*; do
    chmod 755 "$file"
done

### Initialize husky
npx husky install
