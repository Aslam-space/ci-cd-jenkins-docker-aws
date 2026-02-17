# ================= STAGE 1: Build/Prepare =================
FROM alpine:latest AS builder

# Install necessary tools for metadata processing and monitoring scripts
RUN apk add --no-cache bash sed curl

# Set working directory
WORKDIR /app

# Copy only app files needed for final site
COPY app/ ./app/
COPY index.html ./app/
# Ensure permissions
RUN chmod -R 755 /app

# Optional: create a simple container health script inside container
RUN echo '#!/bin/sh\n' \
         'if ! curl -sSf http://localhost/ >/dev/null; then\n' \
         '  echo "Container unhealthy!" >&2\n' \
         '  exit 1\n' \
         'fi' \
    > /app/check_health.sh && chmod +x /app/check_health.sh

# ================= STAGE 2: Production Nginx =================
FROM nginx:alpine

# Remove default HTML
RUN rm -rf /usr/share/nginx/html/*

# Copy app from builder stage
COPY --from=builder /app /usr/share/nginx/html

# Copy custom nginx config if exists
COPY app/nginx /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Health check for Docker itself
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD /usr/share/nginx/html/check_health.sh

# Optional: install lightweight monitoring tools inside container
# (curl is already copied from builder)
RUN apk add --no-cache bash curl jq

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
