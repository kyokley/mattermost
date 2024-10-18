.PHONY: up down

up:
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

down:
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml down
