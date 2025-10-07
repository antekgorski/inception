# Install nginx on debian stable-slim
FROM debian:stable-slim
# Install nginx + openssl, prepare dirs, cleanup
RUN apt-get update && apt-get install -y \
    nginx openssl && \
    mkdir -p /etc/nginx/ssl /run/nginx && \
    rm -rf /var/lib/apt/lists/*

# Copy nginx conf and entrypoint script
COPY nginx.conf /etc/nginx/nginx.conf
COPY --chmod=755 tools/entrypoint.sh /entrypoint.sh

# Open ports for https 
EXPOSE 443

# Run entrypoint script
ENTRYPOINT ["/entrypoint.sh"]