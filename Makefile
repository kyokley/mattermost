.PHONY: up down

up:
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml up -d

down:
	docker compose -f docker-compose.yml -f docker-compose.without-nginx.yml down

init:
	rm -rv ./volumes/app/mattermost || true
	rm -rv $$(pwd)/certs || true
	mkdir -p ./volumes/app/mattermost/{config,data,logs,plugins,client/plugins,bleve-indexes}
	sudo chown -R 2000:2000 ./volumes/app/mattermost
	bash scripts/issue-certificate.sh -d $$(grep '^DOMAIN=' .env | awk -F= '{print $2}') -o $$(pwd)/certs
