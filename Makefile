# Variables
tag := red
service := firecrawl
port := 3000

main_image := registry.internal.telnyx.com/jenkins/$(service):$(tag)
node_version := 22.14.0

.PHONY: build
build:
	docker compose build

.PHONY: start
start:
	docker compose up

.PHONY: test
test:
	$(info ************  NO TESTING YET ************)

.PHONY: dev-deploy
dev-deploy:
	git push --force origin HEAD:dev
