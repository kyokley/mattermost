.PHONY: up down

up:
	sudo docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

down:
	sudo docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml down
