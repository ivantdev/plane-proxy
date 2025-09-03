#!/bin/sh

# Set default port if not provided by Railway
export PORT=${PORT:-8080}

# Debug: Print environment variables
echo "=== Environment Variables ==="
echo "PORT: $PORT"
echo "WEB_ENDPOINT: $WEB_ENDPOINT"
echo "ADMIN_ENDPOINT: $ADMIN_ENDPOINT"
echo "API_ENDPOINT: $API_ENDPOINT"
echo "SPACES_ENDPOINT: $SPACES_ENDPOINT"
echo "BUCKET_NAME: $BUCKET_NAME"
echo "BUCKET_ENDPOINT: $BUCKET_ENDPOINT"
echo "=========================="

# Check if variables are properly set (not empty and not containing Railway template syntax)
if [ -z "$WEB_ENDPOINT" ] || echo "$WEB_ENDPOINT" | grep -q '\${{'; then
    echo "ERROR: WEB_ENDPOINT is not properly set: $WEB_ENDPOINT"
    exit 1
fi

if [ -z "$ADMIN_ENDPOINT" ] || echo "$ADMIN_ENDPOINT" | grep -q '\${{'; then
    echo "ERROR: ADMIN_ENDPOINT is not properly set: $ADMIN_ENDPOINT"
    exit 1
fi

if [ -z "$API_ENDPOINT" ] || echo "$API_ENDPOINT" | grep -q '\${{'; then
    echo "ERROR: API_ENDPOINT is not properly set: $API_ENDPOINT"
    exit 1
fi

if [ -z "$SPACES_ENDPOINT" ] || echo "$SPACES_ENDPOINT" | grep -q '\${{'; then
    echo "ERROR: SPACES_ENDPOINT is not properly set: $SPACES_ENDPOINT"
    exit 1
fi

if [ -z "$BUCKET_ENDPOINT" ] || echo "$BUCKET_ENDPOINT" | grep -q '\${{'; then
    echo "ERROR: BUCKET_ENDPOINT is not properly set: $BUCKET_ENDPOINT"
    exit 1
fi

# Ensure URLs have proper protocol
if ! echo "$WEB_ENDPOINT" | grep -q '^https\?://'; then
    export WEB_ENDPOINT="http://$WEB_ENDPOINT"
fi

if ! echo "$ADMIN_ENDPOINT" | grep -q '^https\?://'; then
    export ADMIN_ENDPOINT="http://$ADMIN_ENDPOINT"
fi

if ! echo "$API_ENDPOINT" | grep -q '^https\?://'; then
    export API_ENDPOINT="http://$API_ENDPOINT"
fi

if ! echo "$SPACES_ENDPOINT" | grep -q '^https\?://'; then
    export SPACES_ENDPOINT="http://$SPACES_ENDPOINT"
fi

if ! echo "$BUCKET_ENDPOINT" | grep -q '^https\?://'; then
    export BUCKET_ENDPOINT="http://$BUCKET_ENDPOINT"
fi

# Test connectivity to API endpoint
echo "=== Testing API connectivity ==="
# Extract host and port from API_ENDPOINT (format: http://domain:port)
API_URL_CLEAN=$(echo "$API_ENDPOINT" | sed 's|http[s]*://||')
API_HOST=$(echo "$API_URL_CLEAN" | cut -d':' -f1)
API_PORT=$(echo "$API_URL_CLEAN" | cut -d':' -f2 | cut -d'/' -f1)

# If no port specified, default to 80
if [ "$API_PORT" = "$API_HOST" ]; then
    API_PORT=80
fi

echo "Testing connection to $API_HOST:$API_PORT (Railway private network)"
if nc -z -w5 "$API_HOST" "$API_PORT" 2>/dev/null; then
    echo "✓ Successfully connected to API endpoint"
else
    echo "⚠ Cannot connect to API endpoint $API_HOST:$API_PORT"
    echo "  This might be normal if the API service is still starting up"
fi
echo "==============================="

# Substitute environment variables in nginx config
envsubst '${PORT} ${WEB_ENDPOINT} ${ADMIN_ENDPOINT} ${API_ENDPOINT} ${SPACES_ENDPOINT} ${BUCKET_NAME} ${BUCKET_ENDPOINT}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Debug: Show generated config
echo "=== Generated nginx.conf ==="
cat /etc/nginx/nginx.conf
echo "==========================="

# Start nginx
exec nginx -g 'daemon off;'
