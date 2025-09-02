FROM nginx:alpine

# Install envsubst for environment variable substitution
RUN apk add --no-cache gettext

# Accept build arguments from Railway
ARG PORT=8080
ARG WEB_ENDPOINT
ARG ADMIN_ENDPOINT
ARG API_ENDPOINT
ARG SPACES_ENDPOINT
ARG BUCKET_NAME
ARG BUCKET_ENDPOINT

# Set environment variables for runtime
ENV PORT=${PORT}
ENV WEB_ENDPOINT=${WEB_ENDPOINT}
ENV ADMIN_ENDPOINT=${ADMIN_ENDPOINT}
ENV API_ENDPOINT=${API_ENDPOINT}
ENV SPACES_ENDPOINT=${SPACES_ENDPOINT}
ENV BUCKET_NAME=${BUCKET_NAME}
ENV BUCKET_ENDPOINT=${BUCKET_ENDPOINT}

# Copy nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port
EXPOSE ${PORT}

# Use custom startup script
CMD ["/start.sh"]
