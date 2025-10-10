# inception

A hands-on Docker lab to strengthen system administration skills by building and running multiple Docker images inside a personal virtual machine.

## Project Overview

This project sets up a complete WordPress website infrastructure using Docker containers with a focus on **security best practices**:

- **NGINX** - Web server with SSL/TLS support (TLSv1.2/TLSv1.3)
- **WordPress** - Content management system with PHP-FPM
- **MariaDB** - Database server with optimized configuration

## Security Features

✅ **Docker Secrets** - All sensitive data (passwords) stored in Docker secrets instead of environment variables  
✅ **.gitignore** - Prevents committing sensitive files to version control  
✅ **SSL/TLS** - HTTPS-only with self-signed certificates (TLSv1.2+)  
✅ **No Root Access** - Services run as non-privileged users  
✅ **Secret Validation** - Build process validates all required secrets exist  
✅ **Isolated Network** - Services communicate via dedicated Docker network  

## Prerequisites

- Docker Engine
- Docker Compose
- Make

## Setup

1. **Create secret files** in the `secrets/` directory:

```bash
echo "your_strong_root_password" > secrets/mariadb_root_password.txt
echo "your_db_user_password" > secrets/mariadb_password.txt
echo "your_wp_admin_password" > secrets/wp_admin_password.txt
echo "your_wp_user_password" > secrets/wp_user_password.txt
```

2. **Update configuration** in `srcs/.env`:
   - Set your domain name
   - Configure WordPress settings (title, admin email, etc.)

3. **Build and start services**:

```bash
make        # Build images and start containers
make logs   # View container logs
make ps     # Check container status
```

## Commands

- `make` - Build and start all services
- `make build` - Build Docker images (validates secrets first)
- `make up` - Start containers
- `make down` - Stop containers
- `make clean` - Stop and remove containers/images
- `make fclean` - Full cleanup including data volumes
- `make re` - Rebuild everything from scratch
- `make logs` - Follow container logs
- `make ps` - Show running containers

## Architecture

```
┌─────────────────────────────────────────┐
│           Host Machine                   │
│                                          │
│  ┌────────────────────────────────────┐ │
│  │     Docker Network (inception)     │ │
│  │                                    │ │
│  │  ┌──────┐   ┌──────────┐  ┌─────┐│ │
│  │  │NGINX │──▶│WordPress │──▶│Maria││ │
│  │  │:443  │   │PHP-FPM   │  │DB   ││ │
│  │  │      │   │:9000     │  │:3306││ │
│  │  └──────┘   └──────────┘  └─────┘│ │
│  │      ▲            │          │    │ │
│  │      │            ▼          ▼    │ │
│  │   HTTPS    WordPress   MariaDB   │ │
│  │            Volume      Volume     │ │
│  └────────────────────────────────────┘ │
└─────────────────────────────────────────┘
```

## Directory Structure

```
.
├── Makefile                    # Build automation
├── secrets/                    # Docker secrets (gitignored)
│   ├── README.md              # Secret file documentation
│   ├── mariadb_root_password.txt
│   ├── mariadb_password.txt
│   ├── wp_admin_password.txt
│   └── wp_user_password.txt
└── srcs/
    ├── .env                   # Environment variables (non-sensitive)
    ├── docker-compose.yml     # Service orchestration
    └── requirements/
        ├── mariadb/
        │   ├── Dockerfile
        │   ├── conf/
        │   │   └── my.cnf     # MariaDB configuration
        │   └── tools/
        │       └── init_mariadb.sh
        ├── nginx/
        │   ├── Dockerfile
        │   ├── nginx.conf     # NGINX configuration
        │   └── tools/
        │       └── entrypoint.sh
        └── wordpress/
            ├── Dockerfile
            └── tools/
                └── entrypoint.sh
```

## Security Considerations

- **Secrets Management**: All passwords are stored in Docker secrets (`/run/secrets/` inside containers) and excluded from git
- **SSL Certificates**: Self-signed certificates are generated on first run; use proper certificates in production
- **Database Access**: MariaDB only accessible within Docker network (not exposed to host)
- **File Permissions**: All entrypoint scripts have restricted permissions
- **Input Validation**: Build process validates all required secrets and environment variables

## Troubleshooting

**Build fails with "Missing secret" error:**
- Ensure all required secret files exist in `secrets/` directory
- Check that files contain actual content (not empty)

**Cannot connect to website:**
- Check if containers are running: `make ps`
- View logs: `make logs`
- Verify domain name in `/etc/hosts`: `127.0.0.1 antgor.42.fr`

**Permission denied errors:**
- Ensure data directories exist: `mkdir -p ~/data/mariadb ~/data/wordpress`
- Check directory ownership and permissions
