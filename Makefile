.PHONY: up down

up:
	sudo tailscale funnel --bg --tcp $$(grep '^HTTP_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTP_PORT' .env | awk -F= '{print $$2}')
	sudo tailscale funnel --bg --tcp $$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}')
	sudo tailscale funnel --bg --tcp $$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}')
	docker compose -f docker-compose.yml -f docker-compose.nginx.yml up -d

down:
	docker compose -f docker-compose.yml -f docker-compose.nginx.yml down
	sudo tailscale funnel --bg --tcp $$(grep '^HTTP_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTP_PORT' .env | awk -F= '{print $$2}') off
	sudo tailscale funnel --bg --tcp $$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^HTTPS_PORT' .env | awk -F= '{print $$2}') off
	sudo tailscale funnel --bg --tcp $$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') tcp://localhost:$$(grep '^CALLS_PORT' .env | awk -F= '{print $$2}') off

init:
	sudo rm -rv ./volumes/app/mattermost || true
	sudo rm -rv $$(pwd)/{certs,web/cert} || true
	mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes} ./volumes/web/cert
	sudo chown -R 2000:2000 ./volumes/app/mattermost
	sudo tailscale cert --cert-file $$(grep '^CERT_PATH' .env | awk -F= '{print $$2}') --key-file $$(grep '^KEY_PATH' .env | awk -F= '{print $$2}') $$(grep '^DOMAIN' .env | awk -F= '{print $$2}')

logs:
	docker logs -f mattermost-mattermost-1
