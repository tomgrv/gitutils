#!/bin/sh

### Make sure the workspace folder is owned by the user
git config --global --add safe.directory ${containerWorkspaceFolder:-.}

### Install composer dependencies if composer.json exists
if [ -f ${containerWorkspaceFolder:-.}/composer.json ]; then
    composer install --ignore-platform-reqs --no-interaction --no-progress
fi

### Install npm dependencies if package.json exists
if [ -f ${containerWorkspaceFolder:-.}/package.json ]; then
    npm install --ws --if-present --include-workspace-root
fi

### Init laravel
if [ -f ${containerWorkspaceFolder:-.}/artisan ]; then
    touch $DB_DATABASE
    echo APP_KEY=null > .env
    php -d xdebug.mode=off artisan key:generate --force
    php -d xdebug.mode=off artisan config:cache
    php -d xdebug.mode=off artisan view:cache
    php -d xdebug.mode=off artisan route:cache
    php -d xdebug.mode=off artisan migrate --seed
fi
