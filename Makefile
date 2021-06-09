# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONY: help build dev test test-env

# Docker image name and tag
IMAGE:=jappavoo/bu-cs-book-dev
TAG?=latest
# Shell that make should use
SHELL:=bash

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: DARGS?=
build: ## Make the latest build of the image
	docker build $(DARGS) --rm --force-rm -t $(IMAGE):$(TAG) .

#docker run --rm -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -v "${HOME}":/home/jovyan/work  jappavoo/bu-cs-book-dev:latest
dev: ARGS?=
dev: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOME}":/home/jovyan/work
dev: PORT?=8888
dev: ## Make a container from a tagged image image
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS)
