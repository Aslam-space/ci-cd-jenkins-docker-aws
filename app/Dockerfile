# ================= STAGE 1: Builder =================
FROM node:20-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and install dependencies (optional)
COPY package*.json ./
RUN npm ci --silent || echo "No Node dependencies to install"

# Copy the app folder and other required files
COPY app ./app
COPY index.html ./index.html
COPY metadata.json ./metadata.json

# Ensure proper permissions
RUN chmod -R 755 /app

# ================= STAGE 2: Production Nginx =================
FROM nginx:alpine

# Remove default Nginx HTML
RUN rm -rf /usr/share/nginx/html/*

# Copy app folder from builder stage
COPY --from=builder /app/app /usr/share/nginx/html/app

# Copy index.html and metadata.json
COPY --from=builder /app/index.html /usr/share/nginx/html/index.html
COPY --from=builder /app/metadata.json /usr/share/nginx/html/metadata.json

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Add health check
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s \
  CMD wget -q --spider http://localhost/ || exit 1

# Start Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
