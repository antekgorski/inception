.PHONY: all build up down clean fclean re

# Paths
DOCKER_COMPOSE = srcs/docker-compose.yml
DATA_DIR = /home/$(USER)/data

all: build up

# Create data directories
$(DATA_DIR):
	mkdir -p $(DATA_DIR)/mysql
	mkdir -p $(DATA_DIR)/wordpress

# Build all containers
build: $(DATA_DIR)
	docker-compose -f $(DOCKER_COMPOSE) build

# Start all containers
up: $(DATA_DIR)
	docker-compose -f $(DOCKER_COMPOSE) up -d

# Stop all containers
down:
	docker-compose -f $(DOCKER_COMPOSE) down

# Clean containers and images
clean: down
	docker-compose -f $(DOCKER_COMPOSE) down --rmi all

# Full clean including volumes
fclean: clean
	docker-compose -f $(DOCKER_COMPOSE) down -v
	sudo rm -rf $(DATA_DIR)/mysql/*
	sudo rm -rf $(DATA_DIR)/wordpress/*

# Rebuild everything
re: fclean all

# Show logs
logs:
	docker-compose -f $(DOCKER_COMPOSE) logs -f

# Show status
status:
	docker-compose -f $(DOCKER_COMPOSE) ps
