# inception
A hands-on Docker lab to strengthen system administration skills by building and running multiple Docker images inside a personal virtual machine.

## Overview
This project sets up a complete WordPress infrastructure using Docker with the following components:
- **NGINX**: Web server with TLSv1.2 and TLSv1.3 support
- **WordPress**: Content management system with php-fpm (without nginx)
- **MariaDB**: Database server (without nginx)

## Architecture
- 3 Docker containers with automatic restart on crash
- 2 persistent volumes (WordPress database and website files)
- Custom Docker network for inter-container communication
- No use of `tail -f`, `network: host`, `--link`, or `links:`

## Requirements
- Docker
- Docker Compose
- Make

## Installation

1. Copy the environment example file and configure it:
```bash
cp srcs/.env.example srcs/.env
```

2. Edit `srcs/.env` with your desired configuration values.

3. Build and start the containers:
```bash
make
```

Or use individual commands:
```bash
make build  # Build all containers
make up     # Start all containers
make down   # Stop all containers
make clean  # Stop and remove containers and images
make fclean # Full cleanup including volumes
make re     # Rebuild everything from scratch
make logs   # Show container logs
make status # Show container status
```

## Access
- WordPress site: https://localhost
- Admin panel: https://localhost/wp-admin

## Technical Details

### NGINX
- Listens on port 443 (HTTPS only)
- TLS protocols: TLSv1.2 and TLSv1.3 only
- Self-signed SSL certificate
- Forwards PHP requests to WordPress container via FastCGI

### WordPress
- Runs php-fpm on port 9000
- Automatically installs WordPress using WP-CLI
- Waits for MariaDB to be ready before installation

### MariaDB
- Runs on port 3306
- Automatically initializes database and user
- Persistent storage in volume

### Volumes
- `mariadb_data`: Stores MySQL database files at `/home/${USER}/data/mysql`
- `wordpress_data`: Stores WordPress files at `/home/${USER}/data/wordpress`

### Network
- Custom bridge network `inception_network` for container communication
- No use of deprecated `--link` or `links:` features
- No use of `network: host` mode

### Restart Policy
All containers have `restart: always` policy to automatically restart after crashes.
