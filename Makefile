# Inception Project - Minimal Setup
COMPOSE_FILE = srcs/docker-compose.yml

.PHONY: all build up down clean fclean re logs status

all: build up

build:
	cd srcs && sudo docker compose build

up:
	cd srcs && sudo docker compose up -d

down:
	cd srcs && sudo docker compose down

logs:
	cd srcs && sudo docker compose logs -f

status:
	cd srcs && sudo docker compose ps

clean: down
	sudo docker system prune -f

fclean: down
	cd srcs && sudo docker compose down -v
	sudo docker system prune -af --volumes

re: fclean all
