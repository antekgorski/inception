#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Generate a self-signed SSL certificate if it doesn’t exist
if [ ! -f /etc/nginx/ssl/nginx.crt ]; then
  openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=PL/ST=Mazowieckie/L=Warsaw/O=42School/CN=${DOMAIN_NAME:-localhost}"
fi

# Start nginx in foreground (PID 1)
exec nginx -g "daemon off;"
