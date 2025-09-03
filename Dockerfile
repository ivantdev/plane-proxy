FROM nginx:alpine

# Install envsubst for environment variable substitution and network tools for debugging
RUN apk add --no-cache gettext netcat-openbsd

# Copy nginx configuration template
COPY nginx.conf.template /etc/nginx/nginx.conf.template

# Copy startup script
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Expose port (Railway will set PORT at runtime)
EXPOSE 8080

# Use custom startup script
CMD ["/start.sh"]
