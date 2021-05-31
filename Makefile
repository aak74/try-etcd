#!/usr/bin/make

SHELL = /bin/sh

docker_bin := $(shell command -v docker 2> /dev/null)
docker_compose_bin := $(shell command -v docker-compose 2> /dev/null)

.DEFAULT_GOAL := help

# This will output the help for each task. thanks to https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
help: ## Show this help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo "\n  Allowed for overriding next properties:\n\n\
		Usage example:\n\
		make init"

init: ## init
	mkdir -p data/00
	mkdir -p data/01
	mkdir -p data/02

up: ## Start all containers
	$(docker_compose_bin) up -d --build

down: ## Stop all containers
	$(docker_compose_bin) down

reset: down ## Reset cluster (Stop all containers and remove all data)
	sudo rm -rf ./data/*

put:
	etcdctl put some-key "etcd is awesome"

get1:
	etcdctl get some-key --endpoints=http://127.0.0.1:2379

get2:
	etcdctl get some-key --endpoints=http://127.0.0.1:12379

get3:
	etcdctl get some-key --endpoints=http://127.0.0.1:22379