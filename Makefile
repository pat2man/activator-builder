STI_IMAGE_NAME=ticketfly/activator-builder
CUSTOM_IMAGE_NAME=ticketfly/activator-builder
MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))

TEST_DIR=$(dir $(MAKEFILE_PATH))/test
SCRIPTS_URL=file://$(abspath $(TEST_DIR)/../.sti/bin)

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
	
test: test_sti test_custom
	
test_sti:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(STI_IMAGE_NAME)-candidate TEST_DIR=${TEST_DIR} SCRIPTS_URL=${SCRIPTS_URL} test/run
	
test_custom:
	docker build -t $(CUSTOM_IMAGE_NAME)-candidate .
	docker run -t -i $(CUSTOM_IMAGE_NAME)-candidate