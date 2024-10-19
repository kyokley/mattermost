.PHONY: up down

up:
	sudo tailscale funnel --bg $$(grep '^APP_PORT' .env | awk -F= '{print $2}')
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

down:
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml down
	sudo tailscale funnel --bg $$(grep '^APP_PORT' .env | awk -F= '{print $2}') off

init:
	sudo rm -rv ./volumes/app/mattermost || true
	sudo rm -rv $$(pwd)/certs || true
	mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
	sudo chown -R 2000:2000 ./volumes/app/mattermost
	sudo tailscale funnel --bg 80
	sudo tailscale funnel --bg 443
	sudo bash scripts/issue-certificate.sh -d $$(grep '^DOMAIN=' .env | awk -F= '{print $$2}') -o $$(pwd)/certs
	sudo tailscale funnel --bg 80 off
	sudo tailscale funnel --bg 443 off
