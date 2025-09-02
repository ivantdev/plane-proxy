#!/bin/sh

# Set default port if not provided by Railway
export PORT=${PORT:-8080}

# Substitute environment variables in nginx config
envsubst '${PORT} ${WEB_ENDPOINT} ${ADMIN_ENDPOINT} ${API_ENDPOINT} ${SPACES_ENDPOINT} ${BUCKET_NAME} ${BUCKET_ENDPOINT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Start nginx
exec nginx -g 'daemon off;'
