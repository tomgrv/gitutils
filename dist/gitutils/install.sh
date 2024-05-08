#!/bin/sh

echo "Configuring git for this repo..." | npx chalk-cli --stdin blue

### Go to the module root
cd "$(git rev-parse --show-toplevel)" >/dev/null

### Alias to module root
module=$(readlink -f $(dirname $0))

### Function to linearize json object
linearize_json() {
    jq -r 'paths(scalars) as $p | [($p|join(".")), (getpath($p)|tostring)] | join(" ")' "$1"
}

### For each entry in config.json file next to this file, create corresponding git config from key and value.
### if value is an object, parse it as json and create dotted keys
linearize_json $module/config.json | while read key value; do
    git config --local $key $value
    echo "Created config $key => $value" | npx chalk-cli --stdin green
done


### For each entry in alias.json file next to this file, create corresponding git alias from key and value
for key in $(jq -r 'keys[]' $module/alias.json); do
    value=$(jq -r ".$key" $module/alias.json)
    git config --local alias.$key "!sh -c '$value' - "
    echo "Created alias $key => $value" | npx chalk-cli --stdin green
done

### For each script starting with _, create corresponding git alias without _ from script name
for script in $module/_*.sh; do
    alias=$(basename $script | sed -e 's/^_//g' -e 's/.sh$//g')
    git config --local alias.$alias "!sh -c '$(readlink -f $script)' - "
    echo "Created alias $alias => $(readlink -f $script)" | npx chalk-cli --stdin green
done
