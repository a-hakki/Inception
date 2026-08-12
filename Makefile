all: build up

.PHONY: all build up down clean re

build:
	@echo "Creating host data directories under /home/a-hakki/data"
	mkdir -p /home/a-hakki/data/mariadb
	mkdir -p /home/a-hakki/data/wordpress
	@echo "Building Docker images (compose file: srcs/docker-compose.yml)"
	docker compose -f srcs/docker-compose.yml build

up:
	@echo "Starting containers (detached)"
	docker compose -f srcs/docker-compose.yml up -d --remove-orphans

down:
	@echo "Stopping containers"
	docker compose -f srcs/docker-compose.yml down

clean: down
	@echo "Prune unused images and networks (keeps named volumes)"
	docker system prune -f

re: clean all
