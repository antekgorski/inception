#!/bin/bash

# Inception Project - Requirements Verification Script
# This script verifies that all project requirements are met

echo "╔════════════════════════════════════════════════════════════════╗"
echo "║         Inception Project - Requirements Verification         ║"
echo "╚════════════════════════════════════════════════════════════════╝"
echo ""

PASS_COUNT=0
FAIL_COUNT=0

check_requirement() {
    local description="$1"
    local command="$2"
    
    echo -n "Checking: $description... "
    if eval "$command" > /dev/null 2>&1; then
        echo "✓ PASS"
        ((PASS_COUNT++))
        return 0
    else
        echo "✗ FAIL"
        ((FAIL_COUNT++))
        return 1
    fi
}

cd /home/runner/work/inception/inception

echo "1. CONTAINER REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "NGINX container defined" \
    "grep -q 'container_name: nginx' srcs/docker-compose.yml"

check_requirement "WordPress container defined" \
    "grep -q 'container_name: wordpress' srcs/docker-compose.yml"

check_requirement "MariaDB container defined" \
    "grep -q 'container_name: mariadb' srcs/docker-compose.yml"

echo ""
echo "2. NGINX REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "NGINX has Dockerfile" \
    "test -f srcs/requirements/nginx/Dockerfile"

check_requirement "NGINX uses TLSv1.2 and TLSv1.3 only" \
    "grep -q 'ssl_protocols TLSv1.2 TLSv1.3' srcs/requirements/nginx/conf/nginx.conf"

check_requirement "NGINX listens on port 443" \
    "grep -q 'listen 443 ssl' srcs/requirements/nginx/conf/nginx.conf"

check_requirement "NGINX generates SSL certificate" \
    "grep -q 'openssl req' srcs/requirements/nginx/Dockerfile"

echo ""
echo "3. WORDPRESS REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "WordPress has Dockerfile" \
    "test -f srcs/requirements/wordpress/Dockerfile"

check_requirement "WordPress installs php-fpm" \
    "grep -q 'php.*fpm' srcs/requirements/wordpress/Dockerfile"

check_requirement "WordPress does NOT install nginx" \
    "! grep -qi 'nginx' srcs/requirements/wordpress/Dockerfile"

check_requirement "WordPress listens on port 9000" \
    "grep -q 'listen = 9000' srcs/requirements/wordpress/Dockerfile"

echo ""
echo "4. MARIADB REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "MariaDB has Dockerfile" \
    "test -f srcs/requirements/mariadb/Dockerfile"

check_requirement "MariaDB installs mariadb-server" \
    "grep -q 'mariadb-server' srcs/requirements/mariadb/Dockerfile"

check_requirement "MariaDB does NOT install nginx" \
    "! grep -qi 'nginx' srcs/requirements/mariadb/Dockerfile"

echo ""
echo "5. VOLUME REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "WordPress database volume defined" \
    "grep -q 'mariadb_data:' srcs/docker-compose.yml"

check_requirement "WordPress files volume defined" \
    "grep -q 'wordpress_data:' srcs/docker-compose.yml"

check_requirement "MariaDB uses mariadb_data volume" \
    "grep -A2 'mariadb:' srcs/docker-compose.yml | grep -q 'mariadb_data:/var/lib/mysql'"

check_requirement "WordPress uses wordpress_data volume" \
    "grep -A5 'wordpress:' srcs/docker-compose.yml | grep -q 'wordpress_data:/var/www/html'"

check_requirement "NGINX uses wordpress_data volume" \
    "grep -A5 'nginx:' srcs/docker-compose.yml | grep -q 'wordpress_data:/var/www/html'"

echo ""
echo "6. NETWORK REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "Custom Docker network defined" \
    "grep -q 'inception_network:' srcs/docker-compose.yml"

check_requirement "Network uses bridge driver" \
    "grep -q 'driver: bridge' srcs/docker-compose.yml"

check_requirement "All containers use custom network" \
    "[ $(grep -c 'inception_network' srcs/docker-compose.yml) -ge 3 ]"

echo ""
echo "7. RESTART POLICY REQUIREMENTS"
echo "─────────────────────────────────────────"
check_requirement "All containers have restart policy" \
    "[ $(grep -c 'restart: always' srcs/docker-compose.yml) -eq 3 ]"

echo ""
echo "8. FORBIDDEN PATTERNS"
echo "─────────────────────────────────────────"
check_requirement "No 'tail -f' in scripts" \
    "! grep -r 'tail.*-f' srcs/requirements/*/tools/*.sh"

check_requirement "No 'network: host' usage" \
    "! grep -q 'network.*host' srcs/docker-compose.yml"

check_requirement "No '--link' usage" \
    "! grep -q '\-\-link' srcs/docker-compose.yml"

check_requirement "No 'links:' usage" \
    "! grep -q '^[[:space:]]*links:' srcs/docker-compose.yml"

echo ""
echo "9. CONFIGURATION FILES"
echo "─────────────────────────────────────────"
check_requirement "docker-compose.yml exists" \
    "test -f srcs/docker-compose.yml"

check_requirement "Makefile exists" \
    "test -f Makefile"

check_requirement ".env.example exists" \
    "test -f srcs/.env.example"

check_requirement ".gitignore exists" \
    "test -f .gitignore"

check_requirement "README.md exists" \
    "test -f README.md"

echo ""
echo "10. SCRIPT SYNTAX VALIDATION"
echo "─────────────────────────────────────────"
check_requirement "MariaDB init script syntax valid" \
    "bash -n srcs/requirements/mariadb/tools/init_mariadb.sh"

check_requirement "WordPress install script syntax valid" \
    "bash -n srcs/requirements/wordpress/tools/install_wordpress.sh"

check_requirement "docker-compose.yml syntax valid" \
    "docker compose -f srcs/docker-compose.yml config --quiet"

echo ""
echo "╔════════════════════════════════════════════════════════════════╗"
echo "║                      VERIFICATION SUMMARY                      ║"
echo "╠════════════════════════════════════════════════════════════════╣"
echo "║  Total Checks: $((PASS_COUNT + FAIL_COUNT))"
echo "║  Passed: $PASS_COUNT"
echo "║  Failed: $FAIL_COUNT"
echo "╚════════════════════════════════════════════════════════════════╝"

if [ $FAIL_COUNT -eq 0 ]; then
    echo ""
    echo "🎉 All requirements met! The project is ready for deployment."
    exit 0
else
    echo ""
    echo "⚠️  Some requirements are not met. Please review the failures above."
    exit 1
fi
