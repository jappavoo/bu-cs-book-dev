# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONY: help build dev test test-env

# Docker image name and tag=
IMAGE:=jappavoo/bu-cs-book-dev
TAG?=latest
# Shell that make should use
SHELL:=bash

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'


base-build: DARGS?=
base-build: INAME=$(IMAGE)-base
base-build: ## Make the base image
	docker build $(DARGS) --no-cache --rm --force-rm -t $(INAME):$(TAG) base

base-push: DARGS?=
base-push: INAME?=$(IMAGE)-base
base-push: ## push base image
	docker push $(INAME):$(TAG)

base-root: INAME=$(IMAGE)-base
base-root: ARGS?=/bin/bash
base-root: DARGS?=-u 0
base-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-joyvan: INAME=$(IMAGE)-base
base-joyvan: ARGS?=/bin/bash
base-joyvan: DARGS?=
base-joyvan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-lab: INAME=$(IMAGE)-base
base-lab: ARGS?=
base-lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOME}":/home/jovyan/work
base-lab: PORT?=8888
base-lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS)

base-nb: INAME=$(IMAGE)-base
base-nb: ARGS?=
base-nb: DARGS?=-v "${HOME}":/home/jovyan/work
base-nb: PORT?=8888
base-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS) 

base-unmin-build: DARGS?=
base-unmin-build: INAME=$(IMAGE)-base-unmin
base-unmin-build: ## Make the base-unmin image
	docker build $(DARGS) --no-cache --rm --force-rm -t $(INAME):$(TAG) base-unmin

base-unmin-push: DARGS?=
base-unmin-push: INAME?=$(IMAGE)-base-unmin
base-unmin-push: ## push base-unmin image
	docker push $(INAME):$(TAG)

base-unmin-root: INAME=$(IMAGE)-base-unmin
base-unmin-root: ARGS?=/bin/bash
base-unmin-root: DARGS?=-u 0
base-unmin-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-joyvan: INAME=$(IMAGE)-base-unmin
base-unmin-joyvan: ARGS?=/bin/bash
base-unmin-joyvan: DARGS?=
base-unmin-joyvan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-lab: INAME=$(IMAGE)-base-unmin
base-unmin-lab: ARGS?=
base-unmin-lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOME}":/home/jovyan/work
base-unmin-lab: PORT?=8888
base-unmin-lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-nb: INAME=$(IMAGE)-base-unmin
base-unmin-nb: ARGS?=
base-unmin-nb: DARGS?=-v "${HOME}":/home/jovyan/work
base-unmin-nb: PORT?=8888
base-unmin-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS) 

build: DARGS?=
build: ## Make the latest build of the image
	docker build $(DARGS) --no-cache --rm --force-rm -t $(IMAGE):$(TAG) .

push: DARGS?=
push: ## push latest container image to dockerhub
	docker push $(IMAGE):$(TAG)

root: ARGS?=/bin/bash
root: DARGS?=-u 0
root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

joyvan: ARGS?=/bin/bash
joyvan: DARGS?=
joyvan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

#docker run --rm -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -v "${HOME}":/home/jovyan/work  jappavoo/bu-cs-book-dev:latest
lab: ARGS?=
lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOME}":/home/jovyan/work
lab: PORT?=8888
lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS)

nb: ARGS?=
nb: DARGS?=-v "${HOME}":/home/jovyan/work
nb: PORT?=8888
nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS) 

