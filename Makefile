# Variables
tag := red
service := firecrawl
port := 3000

main_image := registry.internal.telnyx.com/jenkins/$(service):$(tag)
node_version := 22.14.0

GIT_COMMIT := $(shell git show -s --format=%H)
GIT_COMMIT_DATE := $(shell git show -s --format=%ci)
BUILD_DATE := $(shell date -u +"%Y-%m-%dT%T.%N%Z")
BUILD_URL := $(BUILD_URL)

.PHONY: build
build:
	MAIN_IMAGE=$(main_image) \
	GIT_COMMIT=$(GIT_COMMIT) \
	GIT_COMMIT_DATE="$(GIT_COMMIT_DATE)" \
	BUILD_DATE=$(BUILD_DATE) \
	BUILD_URL=$(BUILD_URL) \
	VER_NODE=$(node_version) \
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
