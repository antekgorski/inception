.PHONY: all build up down clean fclean re

all: build up

build:
	@echo "Building Docker images..."
	@mkdir -p ~/data/mariadb ~/data/wordpress
	@docker-compose -f srcs/docker-compose.yml build

up:
	@echo "Starting containers..."
	@docker-compose -f srcs/docker-compose.yml up -d

down:
	@echo "Stopping containers..."
	@docker-compose -f srcs/docker-compose.yml down

clean: down
	@echo "Removing containers and images..."
	@docker-compose -f srcs/docker-compose.yml down -v --rmi all

fclean: clean
	@echo "Removing all data..."
	@sudo rm -rf ~/data/mariadb ~/data/wordpress
	@docker system prune -af --volumes

re: fclean all

logs:
	@docker-compose -f srcs/docker-compose.yml logs -f

ps:
	@docker-compose -f srcs/docker-compose.yml ps
