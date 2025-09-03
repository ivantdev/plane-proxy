# Plane Proxy - Nginx Reverse Proxy

This Docker container provides an nginx-based reverse proxy that replicates Caddy functionality for Railway deployment.

## Environment Variables

The following environment variables need to be set:

- `PORT` - Port to listen on (automatically set by Railway)
- `WEB_ENDPOINT` - Main web application endpoint
- `ADMIN_ENDPOINT` - Admin/god-mode endpoint  
- `API_ENDPOINT` - API endpoint (used for both /api/* and /auth/*)
- `SPACES_ENDPOINT` - Spaces endpoint
- `BUCKET_NAME` - Name of the bucket for storage endpoint
- `BUCKET_ENDPOINT` - Storage bucket endpoint

## Routing

The proxy handles the following routes:

- `/` - Routes to `WEB_ENDPOINT`
- `/god-mode/*` - Routes to `ADMIN_ENDPOINT`
- `/api/*` - Routes to `API_ENDPOINT`
- `/auth/*` - Routes to `API_ENDPOINT`
- `/spaces/*` - Routes to `SPACES_ENDPOINT`
- `/${BUCKET_NAME}/*` - Routes to `BUCKET_ENDPOINT`

## Features

- JSON formatted access and error logs
- Proper header forwarding for upstream services
- Trusted proxy configuration for Railway
- Environment variable substitution at runtime

## Building and Running

```bash
# Build the image
docker build -t plane-proxy .

# Run locally (example)
docker run -p 8080:8080 \
  -e WEB_ENDPOINT=http://web:3000 \
  -e ADMIN_ENDPOINT=http://admin:3001 \
  -e API_ENDPOINT=http://api:8000 \
  -e SPACES_ENDPOINT=http://spaces:3002 \
  -e BUCKET_NAME=uploads \
  -e BUCKET_ENDPOINT=http://minio:9000 \
  plane-proxy
```

## Railway Deployment

### Important: Railway Template Variable Resolution

Railway's template variables like `${{service.RAILWAY_PRIVATE_DOMAIN}}` need to be resolved at deployment time, not build time. Make sure your environment variables are properly configured.

### Required Environment Variables in Railway:

**Correct format for Railway:**
```
WEB_ENDPOINT=${{plane-frontend.RAILWAY_PRIVATE_DOMAIN}}
ADMIN_ENDPOINT=${{plane-space.RAILWAY_PRIVATE_DOMAIN}}
API_ENDPOINT=${{plane-backend.RAILWAY_PRIVATE_DOMAIN}}
SPACES_ENDPOINT=${{plane-space.RAILWAY_PRIVATE_DOMAIN}}
BUCKET_NAME=${{shared.S3_BUCKET}}
BUCKET_ENDPOINT=${{shared.S3_ENDPOINT}}
```

**Note:** Remove the extra quotes and make sure the service names match exactly your Railway services.

### Troubleshooting:

1. **Invalid URL prefix error**: This means Railway template variables aren't resolving properly
2. **Check service names**: Ensure service names in templates match your actual Railway service names
3. **Check shared variables**: Make sure shared variables like `S3_BUCKET` and `S3_ENDPOINT` are properly defined in Railway

### Railway Service Names:
Make sure these match your actual Railway service names:
- `plane-frontend` 
- `plane-space`
- `plane-backend` (or `plane-backend/api` if using subdirectory)
- `shared` (for shared variables)

Railway will automatically:
1. Resolve template variables at deployment time
2. Pass resolved values as environment variables
3. Build and deploy the container
