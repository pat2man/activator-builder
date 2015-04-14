ACTIVATOR_VERSION=1.3.2
IMAGE_NAME=ticketfly/activator-builder
MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))

TEST_DIR=$(dir $(MAKEFILE_PATH))
SCRIPTS_URL=file://$(abspath $(TEST_DIR)/../.sti/bin)

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run