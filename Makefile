# Variables
tag := red
service := firecrawl
port := 3000

main_image := registry.internal.telnyx.com/jenkins/$(service):$(tag)
node_version := 22.14.0

docker_build_args = \
	--build-arg GIT_COMMIT=$(shell git show -s --format=%H) \
	--build-arg GIT_COMMIT_DATE="$(shell git show -s --format=%ci)" \
	--build-arg IMAGE_NAME=$(service) \
	--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%T.%N%Z") \
	--build-arg BUILD_URL=$(BUILD_URL) \
	--build-arg VER_NODE=$(node_version)

.PHONY: build
build:
	docker-compose build --build-arg $(docker_build_args)

.PHONY: start
start:
	docker-compose up

.PHONY: test
test:
	$(info ************  NO TESTING YET ************)

.PHONY: dev-deploy
dev-deploy:
	git push --force origin HEAD:dev
