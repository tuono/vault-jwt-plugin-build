#!/bin/bash
#
# Copyright (C) 2020 Tuono, Inc.
# All Rights Reserved

set -e

SOURCE_DIR=jwt-plugin
BUILD_CONTAINER_VERSION=$(cat ${SOURCE_DIR}/GO_VERSION | tr -d '\n')
PLUGIN_VERSION=$(cat ${SOURCE_DIR}/PLUGIN_VERSION | tr -d '\n')
PLUGIN_BASE_NAME=vault-plugin-auth-jwt
PLUGIN_NAME="${PLUGIN_BASE_NAME}.${PLUGIN_VERSION}"

if [[ -z "${CI}" ]]; then
  CI=false
fi

if ${CI} && [[ -z "${FURY_TOKEN}" ]]; then
  echo "FURY_TOKEN not found.  Please set FURY_TOKEN in order to build."
fi

mkdir -p ${SOURCE_DIR}/bin
chmod 777 ${SOURCE_DIR}/bin

docker pull golang:${BUILD_CONTAINER_VERSION}

docker run --rm \
    -e "CI=${CI}" \
    -e "FURY_TOKEN=${FURY_TOKEN}" \
    -e "TARGET_VERSION=${PLUGIN_VERSION}" \
    -v "$(pwd)/${SOURCE_DIR}":/usr/src/myapp \
    -w /usr/src/myapp golang:${BUILD_CONTAINER_VERSION} ./inner_build.sh

SHASUM=$(shasum -a 256 "${SOURCE_DIR}/bin/${PLUGIN_NAME}" | cut -d " " -f1)
echo "JWT PLUGIN SUM: ${SHASUM}"

echo "$SHASUM" > "$(pwd)/${SOURCE_DIR}/bin/shasum"
echo "$PLUGIN_NAME" > "$(pwd)/${SOURCE_DIR}/bin/cmd"

tar -zcvf tuono-jwt-plugin.tar.gz -C jwt-plugin/bin/ .
