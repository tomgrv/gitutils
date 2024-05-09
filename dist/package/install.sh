#!/bin/sh

echo "Merge all package folder json files into top level package.json" | npx chalk-cli --stdin blue

### Go to the module root
cd "$(git rev-parse --show-toplevel)" >/dev/null

### Alias to module root
module=$(dirname $(readlink -f $0))

### Merge all package folder json files into top level package.json
find $module -name _*.json | sort | while read file; do

    echo "Merge $file" | npx chalk-cli --stdin yellow
    jq -s '.[1] * .[0]' $file package.json > /tmp/package.json

    #jq -S . /tmp/package.json > ./package.json
    mv -f /tmp/package.json package.json
done
