# this was seeded from https://github.com/umsi-mads/education-notebook/blob/master/Makefile
.PHONY: help build dev test test-env

# Docker image name and tag=
IMAGE:=jappavoo/bu-cs-book-dev
TAG?=latest
# BASE_IMAGE
BASE?=jupyter

# our latest is built from a know stable base version
BASE_STABLE_VERSION=@sha256:4e21f5507949fe2327420f8caf3cd850a87b13aaea0fe8ed3717e369497d4f54
# our testing version is built from the latest/bleeding edge version of the base image
BASE_TEST_VERSION=:latest
# Shell that make should use
SHELL:=bash
# force no caching for docker builds
#DCACHING=--no-cache

SSH_PORT?=2222

# we mount here to match operate first
MOUNT_DIR=/opt/app-root/src
HOST_DIR=${HOME}
help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

ifeq ($(BASE),jupyter)
  BASE_IMAGE=jupyter/minimal-notebook
  ifeq ($(TAG),latest)
    BASE_VERSION=$(BASE_STABLE_VERSION)
  else
    BASE_VERSION=$(BASE_TEST_VERSION)
  endif
else
  BASE_IMAGE=gradescope/auto-builds
  BASE_VERSION=:ubuntu-20.04
  IMAGE:=jappavoo/bu-cs-book-gradescope
endif

base-build: DARGS?=--build-arg BASE_IMAGE=$(BASE_IMAGE) --build-arg BASE_VERSION=$(BASE_VERSION)
base-build: INAME=$(IMAGE)-base
base-build: ## Make the base image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(INAME):$(TAG) base

base-push: DARGS?=
base-push: INAME?=$(IMAGE)-base
base-push: ## push base image
	docker push $(INAME):$(TAG)

base-root: INAME=$(IMAGE)-base
base-root: ARGS?=/bin/bash
base-root: DARGS?=-u 0
base-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-jovyan: INAME=$(IMAGE)-base
base-jovyan: ARGS?=/bin/bash
base-jovyan: DARGS?=
base-jovyan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-lab: INAME=$(IMAGE)-base
base-lab: ARGS?=
base-lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOST_DIR}":"${MOUNT_DIR}"
base-lab: PORT?=8888
base-lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS)

base-nb: INAME=$(IMAGE)-base
base-nb: ARGS?=
base-nb: DARGS?=-v "${HOST_DIR}":"${MOUNT_DIR}"
base-nb: PORT?=8888
base-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS) 

base-unmin-build: DARGS?=--build-arg VERSION=$(TAG)
base-unmin-build: INAME=$(IMAGE)-base-unmin
base-unmin-build: ## Make the base-unmin image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(INAME):$(TAG) base-unmin

base-unmin-push: DARGS?=
base-unmin-push: INAME?=$(IMAGE)-base-unmin
base-unmin-push: ## push base-unmin image
	docker push $(INAME):$(TAG)

base-unmin-root: INAME=$(IMAGE)-base-unmin
base-unmin-root: ARGS?=/bin/bash
base-unmin-root: DARGS?=-u 0
base-unmin-root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-jovyan: INAME=$(IMAGE)-base-unmin
base-unmin-jovyan: ARGS?=/bin/bash
base-unmin-jovyan: DARGS?=
base-unmin-jovyan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-lab: INAME=$(IMAGE)-base-unmin
base-unmin-lab: ARGS?=
base-unmin-lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOST_DIR}":"${MOUNT_DIR}"
base-unmin-lab: PORT?=8888
base-unmin-lab: ## start a jupyter lab notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS)

base-unmin-nb: INAME=$(IMAGE)-base-unmin
base-unmin-nb: ARGS?=
base-unmin-nb: DARGS?=-v "${HOST_DIR}":"${MOUNT_DIR}"
base-unmin-nb: PORT?=8888
base-unmin-nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(INAME):$(TAG) $(ARGS) 

build: DARGS?=--build-arg VERSION=$(TAG)
build: ## Make the latest build of the image
	docker build $(DARGS) $(DCACHING) --rm --force-rm -t $(IMAGE):$(TAG) .

push: DARGS?=
push: ## push latest container image to dockerhub
	docker push $(IMAGE):$(TAG)

root: ARGS?=/bin/bash
root: DARGS?=-u 0
root: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

jovyan: ARGS?=/bin/bash
jovyan: DARGS?=
jovyan: ## start container with root shell to do admin and poke around
	docker run -it --rm $(DARGS) $(IMAGE):$(TAG) $(ARGS)

#docker run --rm -e JUPYTER_ENABLE_LAB=yes -p 8888:8888 -v "${HOME}":/home/jovyan/work  jappavoo/bu-cs-book-dev:latest
lab: ARGS?=
lab: DARGS?=-e JUPYTER_ENABLE_LAB=yes -v "${HOST_DIR}":"${MOUNT_DIR}" -p ${SSH_PORT}:22
lab: PORT?=8888
lab: ## start a jupyter lab notebook server container instance
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS)
#	docker run -it --privileged --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS)

nb: ARGS?=
nb: DARGS?=-v "${HOST_DIR}":"${MOUNT_DIR}" -p ${SSH_PORT}:22
nb: PORT?=8888
nb: ## start a jupyter classic notebook server container instance 
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(IMAGE):$(TAG) $(ARGS) 

