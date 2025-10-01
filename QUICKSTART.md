# Quick Reference Guide

## First Time Setup

```bash
# 1. Clone the repository
git clone <repository-url>
cd inception

# 2. Configure environment
cp srcs/.env.example srcs/.env
# Edit srcs/.env with your configuration

# 3. Build and start
make

# 4. Access WordPress
# Open browser to: https://localhost
# (Accept the self-signed certificate warning)
```

## Common Commands

```bash
make           # Build and start all containers
make down      # Stop all containers
make logs      # View logs
make status    # Check container status
make clean     # Remove containers and images
make fclean    # Full cleanup including data
make re        # Rebuild from scratch
```

## Verify Setup

```bash
./verify_requirements.sh
```

## Architecture

```
[Client] --HTTPS--> [NGINX:443] --FastCGI--> [WordPress:9000] --MySQL--> [MariaDB:3306]
                        |                          |
                        v                          v
                   [wordpress_data]           [mariadb_data]
```

## Container Details

| Container | Port | Purpose | Base Image |
|-----------|------|---------|------------|
| nginx | 443 | HTTPS server with TLS 1.2/1.3 | debian:bullseye |
| wordpress | 9000 | PHP-FPM for WordPress | debian:bullseye |
| mariadb | 3306 | Database server | debian:bullseye |

## Volumes

| Volume | Container Mount | Host Location | Purpose |
|--------|----------------|---------------|---------|
| mariadb_data | /var/lib/mysql | ~/data/mysql | Database storage |
| wordpress_data | /var/www/html | ~/data/wordpress | WordPress files |

## Network

- **Name**: inception_network
- **Type**: bridge
- **Containers**: All 3 containers connected
- **Communication**: Via service names (mariadb, wordpress, nginx)

## Requirements Checklist

✓ Container 1: NGINX with TLSv1.2/1.3 only
✓ Container 2: WordPress with php-fpm (no nginx)
✓ Container 3: MariaDB (no nginx)
✓ Volume 1: WordPress database
✓ Volume 2: WordPress files
✓ Docker network connection
✓ Automatic restart on crash
✓ No tail -f or similar hacks
✓ No network: host, --link, or links:

## Troubleshooting

### Containers won't start
```bash
make logs  # Check the logs for errors
```

### Database connection errors
```bash
# Ensure MariaDB is ready
docker compose -f srcs/docker-compose.yml ps
# Check MariaDB logs
docker compose -f srcs/docker-compose.yml logs mariadb
```

### Permission issues
```bash
# Ensure data directories exist
mkdir -p ~/data/mysql ~/data/wordpress
```

### SSL certificate warnings
This is normal for self-signed certificates. For production, use a proper CA-signed certificate.

### Reset everything
```bash
make fclean  # Warning: This deletes all data!
make
```

## File Locations

| File | Description |
|------|-------------|
| `Makefile` | Build commands |
| `README.md` | Full documentation |
| `IMPLEMENTATION.md` | Technical details |
| `verify_requirements.sh` | Requirements checker |
| `srcs/docker-compose.yml` | Container orchestration |
| `srcs/.env` | Environment config (gitignored) |
| `srcs/.env.example` | Config template |
| `srcs/requirements/nginx/` | NGINX container |
| `srcs/requirements/wordpress/` | WordPress container |
| `srcs/requirements/mariadb/` | MariaDB container |

## Environment Variables

Key variables in `.env`:
- `MYSQL_ROOT_PASSWORD` - MariaDB root password
- `MYSQL_DATABASE` - WordPress database name
- `MYSQL_USER` - WordPress database user
- `MYSQL_PASSWORD` - WordPress database password
- `WORDPRESS_ADMIN_USER` - WordPress admin username
- `WORDPRESS_ADMIN_PASSWORD` - WordPress admin password
- `WORDPRESS_ADMIN_EMAIL` - WordPress admin email
- `DOMAIN_NAME` - Your domain name

## Security Notes

1. Change all default passwords in `.env`
2. Never commit `.env` file to git
3. Use proper SSL certificates in production
4. Keep base images updated
5. Regularly backup volume data

## Next Steps

1. Configure your domain name in `.env`
2. Set strong passwords
3. For production: Replace self-signed certificate
4. Configure firewall rules
5. Set up regular backups
6. Add monitoring and health checks
