#!/bin/bash

# -------------------------
# Variables
# -------------------------
IMAGE_NAME="ci-cd-static:latest"
CONTAINER_NAME="ci-cd-container"
APP_DIR="app"

# -------------------------
# Stop and remove old container
# -------------------------
docker ps -q --filter "name=${CONTAINER_NAME}" | xargs -r docker stop
docker ps -aq --filter "name=${CONTAINER_NAME}" | xargs -r docker rm

# -------------------------
# Create proper nginx config inside app/
# -------------------------
cat > $APP_DIR/nginx.conf <<EOL
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /images/ {
        expires 7d;
        add_header Cache-Control "public";
    }

    gzip on;
    gzip_types text/plain text/css application/javascript application/json image/svg+xml;
    gzip_min_length 256;
}
EOL

# -------------------------
# Inject build metadata & cache-bust
# -------------------------
BUILD_NUMBER=$(date +%Y%m%d%H%M%S)   # example build number
GIT_COMMIT=$(git -C $APP_DIR rev-parse --short HEAD 2>/dev/null || echo "unknown")
TIMESTAMP=$(date +%s)

sed -i "s/{{BUILD_NUMBER}}/$BUILD_NUMBER/g" $APP_DIR/index.html
sed -i "s/{{GIT_COMMIT}}/$GIT_COMMIT/g" $APP_DIR/index.html
sed -i "s/{{CACHE_BUST}}/$TIMESTAMP/g" $APP_DIR/index.html

# -------------------------
# Create Dockerfile inside app/ if not exists
# -------------------------
cat > $APP_DIR/Dockerfile <<EOL
FROM nginx:alpine
COPY . /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EOL

# -------------------------
# Build Docker image
# -------------------------
docker build -t $IMAGE_NAME $APP_DIR

# -------------------------
# Run new container
# -------------------------
docker run -d --name $CONTAINER_NAME -p 8090:80 $IMAGE_NAME

# -------------------------
# Show running container
# -------------------------
docker ps -a | grep $CONTAINER_NAME
