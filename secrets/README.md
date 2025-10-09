# Secrets Configuration

This directory contains Docker secrets used by the services.

## Required Files

Create the following files with appropriate passwords/secrets:

- `mariadb_root_password.txt` - MariaDB root password
- `mariadb_password.txt` - MariaDB user password (for WordPress database user)
- `wp_admin_password.txt` - WordPress admin password
- `wp_user_password.txt` - WordPress additional user password

## Example

```bash
echo "your_root_password" > mariadb_root_password.txt
echo "your_user_password" > mariadb_password.txt
echo "your_admin_password" > wp_admin_password.txt
echo "your_user_password" > wp_user_password.txt
```

**Note:** These files are excluded from git via `.gitignore` to prevent committing sensitive data.
