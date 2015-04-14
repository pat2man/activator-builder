IMAGE_NAME=ticketfly/activator-builder
MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))
TEST_DIR=$(dirname "${MAKEFILE_PATH}")

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	echo "Makefile path ${MAKEFILE_PATH}"
	echo "Test dir ${TEST_DIR}"
	# docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate TEST_DIR=${TEST_DIR} test/run