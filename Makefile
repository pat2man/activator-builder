STI_IMAGE_NAME=sbt-sti-builder
CUSTOM_IMAGE_NAME=sbt-builder
MAKEFILE_PATH=$(abspath $(lastword $(MAKEFILE_LIST)))

TEST_DIR=$(dir $(MAKEFILE_PATH))/test
SCRIPTS_URL=file://$(dir $(MAKEFILE_PATH))/.sti/bin

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
	
test: test_sti test_custom
	
test_sti:
	docker build -t $(STI_IMAGE_NAME)-candidate .
	IMAGE_NAME=$(STI_IMAGE_NAME)-candidate \
		TEST_DIR=${TEST_DIR} \
		SCRIPTS_URL=${SCRIPTS_URL} \
		test/run
	
test_custom:
	docker build -t $(CUSTOM_IMAGE_NAME)-candidate .
	IMAGE_NAME=$(CUSTOM_IMAGE_NAME)-candidate \
		TEST_DIR=${TEST_DIR} \
		test/run_custom