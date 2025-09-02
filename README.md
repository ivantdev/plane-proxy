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

Railway automatically passes environment variables as build arguments during the Docker build process. 

### Required Environment Variables in Railway:

Set these variables in Railway's dashboard:

- `PORT` - Port to listen on (automatically set by Railway, defaults to 8080)
- `WEB_ENDPOINT` - Main web application endpoint
- `ADMIN_ENDPOINT` - Admin/god-mode endpoint  
- `API_ENDPOINT` - API endpoint (used for both /api/* and /auth/*)
- `SPACES_ENDPOINT` - Spaces endpoint
- `BUCKET_NAME` - Name of the bucket for storage endpoint
- `BUCKET_ENDPOINT` - Storage bucket endpoint

Railway will automatically:
1. Pass these environment variables as build arguments to Docker
2. Build the image with the configuration baked in
3. Deploy the container

No additional configuration needed - just set the environment variables in Railway's dashboard and deploy from this repository.
