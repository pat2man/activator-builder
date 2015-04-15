#!/bin/bash
set -o pipefail
IFS=$'\n\t'

DOCKER_SOCKET=${DOCKER_SOCKET:="/var/run/docker.sock"}

if [ ! -e "${DOCKER_SOCKET}" ]; then
  echo "Docker socket missing at ${DOCKER_SOCKET}"
  exit 1
fi

if [ -n "${OUTPUT_IMAGE}" ]; then
  TAG="${OUTPUT_REGISTRY}/${OUTPUT_IMAGE}"
fi

if [[ "${SOURCE_REPOSITORY}" != "git://"* ]] && [[ "${SOURCE_REPOSITORY}" != "git@"* ]]; then
  URL="${SOURCE_REPOSITORY}"
  if [[ "${URL}" != "http://"* ]] && [[ "${URL}" != "https://"* ]]; then
    URL="https://${URL}"
  fi
  curl --head --silent --fail --location --max-time 16 $URL > /dev/null
  if [ $? != 0 ]; then
    echo "Not found: ${SOURCE_REPOSITORY}"
    exit 1
  fi
fi

ACTIVATOR_CMD="sbt"

if [ -e "./activator" ]; then
  ACTIVATOR_CMD="./activator"
fi

if [ -n "${SOURCE_REF}" ]; then
  BUILD_DIR=$(mktemp --directory --suffix=docker-build)
  git clone --recursive "${SOURCE_REPOSITORY}" "${BUILD_DIR}"
  if [ $? != 0 ]; then
    echo "Error trying to fetch git source: ${SOURCE_REPOSITORY}"
    exit 1
  fi
  pushd "${BUILD_DIR}"
  if [ -n "${SOURCE_REF}" ]; then
    git checkout "${SOURCE_REF}"
    if [ $? != 0 ]; then
      echo "Error trying to checkout branch: ${SOURCE_REF}"
      exit 1
    fi
  fi
  ${ACTIVATOR_CMD} docker:stage
  if [ ! -e "target/docker/Dockerfile" ]; then
    echo "Docker build unsuccessful"
    exit 1
  fi
  cd target/docker
  docker build --rm -t "${TAG}" "${BUILD_DIR}"
  popd
else
  ${ACTIVATOR_CMD} docker:stage
  if [ ! -e "target/docker/Dockerfile" ]; then
    echo "Docker build unsuccessful"
    exit 1
  fi
  cd target/docker
  docker build --rm -t "${TAG}" "${SOURCE_REPOSITORY}"
fi

if [ -n "${OUTPUT_IMAGE}" ] || [ -s "/root/.dockercfg" ]; then
  docker push "${TAG}"
fi