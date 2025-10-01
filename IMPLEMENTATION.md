# Inception Project - Complete Implementation

## ✅ All Requirements Met

This project successfully implements a complete Docker infrastructure according to all specified requirements.

### 1. Container 1: NGINX with TLSv1.2 or TLSv1.3 only ✓
- **Location**: `srcs/requirements/nginx/`
- **TLS Configuration**: Explicitly configured with `ssl_protocols TLSv1.2 TLSv1.3;` in nginx.conf
- **Port**: Listens on 443 (HTTPS only)
- **SSL**: Self-signed certificate generated during Docker build
- **Function**: Acts as reverse proxy, forwards PHP requests to WordPress via FastCGI

### 2. Container 2: WordPress with php-fpm (without nginx) ✓
- **Location**: `srcs/requirements/wordpress/`
- **PHP-FPM**: Installs and configures php7.4-fpm
- **Port**: Listens on port 9000 for FastCGI
- **No NGINX**: Dockerfile explicitly does not install nginx
- **Auto-Install**: Uses WP-CLI to automatically install WordPress
- **Database**: Waits for MariaDB to be ready before installation

### 3. Container 3: MariaDB (without nginx) ✓
- **Location**: `srcs/requirements/mariadb/`
- **Database**: MariaDB server for WordPress
- **Port**: Listens on port 3306
- **No NGINX**: Dockerfile explicitly does not install nginx
- **Initialization**: Automatically creates database and user on first run

### 4. Volume 1: WordPress Database ✓
- **Volume Name**: `mariadb_data`
- **Mount Point**: `/var/lib/mysql` in MariaDB container
- **Storage**: `/home/${USER}/data/mysql` on host
- **Purpose**: Persistent storage for MySQL database files

### 5. Volume 2: WordPress Website Files ✓
- **Volume Name**: `wordpress_data`
- **Mount Point**: `/var/www/html` in both WordPress and NGINX containers
- **Storage**: `/home/${USER}/data/wordpress` on host
- **Purpose**: Persistent storage for WordPress installation files

### 6. Docker Network Connection ✓
- **Network Name**: `inception_network`
- **Type**: Custom bridge network
- **Containers**: All three containers connected
- **DNS**: Containers communicate using service names (mariadb, wordpress, nginx)

### 7. Automatic Restart After Crash ✓
- **Policy**: All containers have `restart: always`
- **Behavior**: Docker automatically restarts containers if they stop or crash

### 8. No 'tail -f' or Similar Hacks ✓
- **MariaDB**: Uses `exec mysqld` (proper foreground mode)
- **WordPress**: Uses `exec php-fpm7.4 -F` (foreground mode)
- **NGINX**: Uses `nginx -g "daemon off;"` (daemon off mode)

### 9. Forbidden Network Configurations ✓
- ❌ Does NOT use `network: host`
- ❌ Does NOT use `--link`
- ❌ Does NOT use `links:` directive
- ✅ Uses modern Docker networking with custom bridge network

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                         Host System                          │
│                                                               │
│  ┌──────────────────────────────────────────────────────┐   │
│  │           inception_network (Bridge)                  │   │
│  │                                                        │   │
│  │  ┌──────────────┐  ┌──────────────┐  ┌────────────┐ │   │
│  │  │    NGINX     │  │  WordPress   │  │  MariaDB   │ │   │
│  │  │   (TLS 1.2/3)│  │  (php-fpm)   │  │            │ │   │
│  │  │   Port: 443  │  │  Port: 9000  │  │ Port: 3306 │ │   │
│  │  └──────┬───────┘  └──────┬───────┘  └─────┬──────┘ │   │
│  │         │                  │                 │        │   │
│  │         └─────────┬────────┴─────────────────┘        │   │
│  └───────────────────┼──────────────────────────────────┘   │
│                      │                                       │
│  ┌──────────────────┴───────────────────────────────────┐   │
│  │                  Volumes                              │   │
│  │  ┌──────────────────┐    ┌────────────────────────┐  │   │
│  │  │  wordpress_data  │    │    mariadb_data        │  │   │
│  │  │  /var/www/html   │    │   /var/lib/mysql       │  │   │
│  │  └──────────────────┘    └────────────────────────┘  │   │
│  └──────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────┘
```

## Request Flow

```
1. Client makes HTTPS request → 2. NGINX (Port 443)
                                  ↓
                      3. Forwards to WordPress via FastCGI
                                  ↓
                      4. WordPress (php-fpm on Port 9000)
                                  ↓
                      5. Queries MariaDB (Port 3306)
                                  ↓
                      6. Response flows back through chain
```

## Quick Start

```bash
# 1. Copy and configure environment
cp srcs/.env.example srcs/.env
vim srcs/.env  # Edit with your values

# 2. Build and start
make

# 3. Access WordPress
# Open browser: https://localhost
```

## Available Make Commands

| Command       | Description                                    |
|---------------|------------------------------------------------|
| `make`        | Build and start all containers                 |
| `make build`  | Build all Docker images                        |
| `make up`     | Start all containers                           |
| `make down`   | Stop all containers                            |
| `make clean`  | Stop and remove containers + images            |
| `make fclean` | Full cleanup including volumes and data        |
| `make re`     | Rebuild everything from scratch                |
| `make logs`   | Show container logs (follow mode)              |
| `make status` | Show current status of all containers          |

## Files Structure

```
inception/
├── Makefile                                    # Build automation
├── README.md                                   # User documentation
├── IMPLEMENTATION.md                           # This file
├── verify_requirements.sh                      # Requirements checker
├── .gitignore                                  # Git ignore rules
└── srcs/
    ├── .env                                    # Environment variables (gitignored)
    ├── .env.example                            # Environment template
    ├── docker-compose.yml                      # Docker Compose config
    └── requirements/
        ├── nginx/
        │   ├── Dockerfile                      # NGINX image
        │   └── conf/
        │       └── nginx.conf                  # NGINX config (TLS 1.2/1.3)
        ├── wordpress/
        │   ├── Dockerfile                      # WordPress + php-fpm image
        │   └── tools/
        │       └── install_wordpress.sh        # WordPress installer
        └── mariadb/
            ├── Dockerfile                      # MariaDB image
            └── tools/
                └── init_mariadb.sh             # Database initializer
```

## Security Features

1. **HTTPS Only**: No HTTP, only HTTPS on port 443
2. **Modern TLS**: Only TLSv1.2 and TLSv1.3 protocols
3. **Strong Ciphers**: Configured with secure cipher suites
4. **Environment Variables**: No hardcoded credentials
5. **Gitignored Secrets**: .env file excluded from version control
6. **Network Isolation**: Containers in isolated bridge network

## Testing & Verification

All configurations have been validated:
- ✓ Docker Compose syntax validated
- ✓ All Dockerfiles syntax checked
- ✓ Shell scripts bash syntax verified
- ✓ NGINX configuration structure validated
- ✓ All 9 requirements verified programmatically

## Production Considerations

1. **SSL Certificates**: Replace self-signed certificate with proper CA-signed certificate
2. **Passwords**: Change default passwords in .env file
3. **Domain**: Update DOMAIN_NAME in .env to your actual domain
4. **Firewall**: Configure host firewall to allow port 443
5. **Backups**: Implement regular backups of volume data
6. **Monitoring**: Add container health checks and monitoring
7. **Updates**: Keep base images and packages updated

## Troubleshooting

### Check container status
```bash
make status
```

### View logs
```bash
make logs
```

### Restart everything
```bash
make re
```

### Full cleanup and rebuild
```bash
make fclean
make
```

## Notes

- Data directories are automatically created by Makefile
- Containers start in dependency order (MariaDB → WordPress → NGINX)
- WordPress waits for MariaDB to be ready before installation
- All containers restart automatically on failure
- Volumes use bind mounts for easy access to data on host

---

**Status**: ✅ Ready for deployment
**Last Updated**: 2024
**All Requirements**: ✓ Implemented and Verified
