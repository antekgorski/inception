.PHONY: all build up down clean fclean re setup-secrets

all: build up

setup-secrets:
@echo "Setting up secrets..."
@if [ ! -s secrets/mariadb_root_password.txt ]; then \
echo "Please create secrets/mariadb_root_password.txt with the root password"; \
exit 1; \
fi
@if [ ! -s secrets/mariadb_password.txt ]; then \
echo "Please create secrets/mariadb_password.txt with the user password"; \
exit 1; \
fi
@if [ ! -s secrets/wp_admin_password.txt ]; then \
echo "Please create secrets/wp_admin_password.txt with the admin password"; \
exit 1; \
fi
@if [ ! -s secrets/wp_user_password.txt ]; then \
echo "Please create secrets/wp_user_password.txt with the user password"; \
exit 1; \
fi
@echo "All secrets are properly configured!"

build: setup-secrets
@echo "Building Docker images..."
@mkdir -p ~/data/mariadb ~/data/wordpress
@docker compose -f srcs/docker-compose.yml build

up:
@echo "Starting containers..."
@docker compose -f srcs/docker-compose.yml up -d

down:
@echo "Stopping containers..."
@docker compose -f srcs/docker-compose.yml down

clean: down
@echo "Removing containers and images..."
@docker compose -f srcs/docker-compose.yml down -v --rmi all

fclean: clean
@echo "Removing all data..."
@sudo rm -rf ~/data/mariadb ~/data/wordpress
@docker system prune -af --volumes

re: fclean all

logs:
@docker compose -f srcs/docker-compose.yml logs -f

ps:
@docker compose -f srcs/docker-compose.yml ps
