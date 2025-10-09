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

1. Create secret files in the `secrets/` directory:
   ```bash
   echo "your_strong_root_password" > secrets/mariadb_root_password.txt
   echo "your_strong_user_password" > secrets/mariadb_password.txt
   echo "your_admin_password" > secrets/wp_admin_password.txt
   echo "your_user_password" > secrets/wp_user_password.txt
   ```

2. Edit `srcs/.env` file with your configuration:
   - Update domain name if needed
   - Set database and WordPress settings
   - **Note**: Passwords are now managed via Docker secrets (see step 1)

3. Build and start the containers:
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

⚠️ **Important**: This project uses Docker secrets for sensitive data!

Passwords are stored in the `secrets/` directory and mounted as Docker secrets:
- `secrets/mariadb_root_password.txt` - MariaDB root password
- `secrets/mariadb_password.txt` - MariaDB user password
- `secrets/wp_admin_password.txt` - WordPress admin password
- `secrets/wp_user_password.txt` - WordPress user password

These files are excluded from git via `.gitignore` to prevent committing sensitive data.

**Before running the project**, you must create these files with strong passwords!

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
