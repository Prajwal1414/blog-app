#! /bin/sh

echo "Injecting runtime vars"
envsubst '$VITE_API_PATH' < /usr/share/nginx/html/assets/env.js.template > /usr/share/nginx/html/assets/env.js

exec "$@"
