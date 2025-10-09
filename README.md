# inception
A hands-on Docker lab to strengthen system administration skills by building and running multiple Docker images inside a personal virtual machine.

## Project Structure

This project sets up a Docker infrastructure with three services:
- **NGINX**: Web server with SSL/TLS (HTTPS)
- **WordPress**: Content Management System with PHP-FPM
- **MariaDB**: Database server

## Services

### NGINX
- Serves HTTPS on port 443
- Configured with TLSv1.2 and TLSv1.3
- Self-signed SSL certificate
- Reverse proxy to WordPress PHP-FPM

### WordPress
- PHP 7.4 with FPM
- WordPress installation via WP-CLI
- Configured to connect to MariaDB
- Two users: admin and editor

### MariaDB
- Database: wordpress
- Configured for network access
- Persistent data storage

## Usage

### Prerequisites
- Docker and Docker Compose installed
- `make` utility

### Configuration

1. Edit `srcs/.env` file with your credentials:
   - Change all passwords (marked with `changeme_`)
   - Update domain name if needed
   - Set WordPress admin and user credentials

2. Build and start the containers:
   ```bash
   make
   ```

### Makefile Commands

- `make` or `make all`: Build images and start containers
- `make build`: Build Docker images
- `make up`: Start containers
- `make down`: Stop containers
- `make clean`: Stop containers and remove images
- `make fclean`: Clean everything including data volumes
- `make re`: Rebuild everything from scratch
- `make logs`: View container logs
- `make ps`: Show running containers

## Data Persistence

Data is stored in:
- `~/data/mariadb`: Database files
- `~/data/wordpress`: WordPress installation

## Security Notes

⚠️ **Important**: Before deploying, change all default passwords in `srcs/.env`!

The default `.env` file contains placeholder passwords that should be changed:
- `MYSQL_PASSWORD`
- `MYSQL_ROOT_PASSWORD`
- `WP_ADMIN_PASSWORD`
- `WP_USER_PASSWORD`

## Accessing WordPress

1. Add your domain to `/etc/hosts`:
   ```
   127.0.0.1 antgor.42.fr
   ```

2. Access WordPress at: `https://antgor.42.fr`

3. Accept the self-signed certificate warning in your browser

## Troubleshooting

View logs for debugging:
```bash
make logs
```

Check container status:
```bash
make ps
```

Rebuild from scratch:
```bash
make re
```
