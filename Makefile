.PHONY: up down init logs shell restart

up:
	sudo tailscale funnel --bg --tcp $$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}')
	sudo tailscale funnel --bg --tcp $$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}')
	docker compose up -d

down:
	docker compose down
	sudo tailscale funnel --bg --tcp $$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') off
	sudo tailscale funnel --bg --tcp $$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') off

init:
	sudo rm -rv ./volumes/app/mattermost || true
	sudo rm -rv $$(pwd)/{certs,web/cert} || true
	mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes} ./volumes/web/cert
	sudo chown -R 2000:2000 ./volumes/app/mattermost

logs:
	docker logs -f mattermost-mattermost-1

shell:
	docker compose exec -it mattermost /bin/bash

certbot-shell:
	docker compose exec -it certbot sh

restart: pull down up

pull:
	docker compose pull
