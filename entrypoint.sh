#!/bin/sh

cd laravel_app

composer install 

# This will exec the CMD from your Dockerfile, i.e. "npm start etc"
exec "$@"