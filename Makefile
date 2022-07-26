DOCKER_REGISTRY := coddyOcat
DEPLOY := listen-push
RELEASE_VERSION := $(shell git describe --tags | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+')

all: clean build start
prod: clean build release
dev: clean build debug

gen:
	go generate ./...
build: gen
	go build -mod=vendor -o ./bin ./main
start:
	export `cat .env | grep -v ^\# | xargs` && export DEBUG='0' &&./bin
debug:
	export `cat .env | grep -v ^\# | xargs` && export DEBUG='1' && ./bin
release:
	export `cat .env | grep -v ^\# | xargs` && export GIN_MODE=release && ./bin

version:
	echo $(RELEASE_VERSION)

docker-build:
	docker build -t $(DOCKER_REGISTRY)/$(DEPLOY):$(RELEASE_VERSION) -f ./Dockerfile .
	docker build -t $(DOCKER_REGISTRY)/$(DEPLOY):latest -f ./Dockerfile .
docker-run:
	docker stop $(DEPLOY) || true
	docker container rm $(DEPLOY) || true
	docker run --name $(DEPLOY) $(DOCKER_REGISTRY)/$(DEPLOY):latest
push:
	docker push $(DOCKER_REGISTRY)/$(DEPLOY):$(RELEASE_VERSION)
	docker push $(DOCKER_REGISTRY)/$(DEPLOY):latest
clean:
	rm -rf ./bin
	go mod tidy