IMAGE_NAME=ticketfly/activator-builder
MAKEFILE_PATH := $(abspath $(lastword $(MAKEFILE_LIST)))
CURRENT_DIR := $(dirname "${MAKEFILE_PATH}")

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	echo "Current dir: ${MAKEFILE_PATH}"
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run