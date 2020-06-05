#!/bin/sh
#
# Copyright (C) 2020 Tuono, Inc.
# All Rights Reserved

set -e

apk add bash build-base curl git zip

HASHI_DIR=/go/src/github.com/hashicorp/
RESULT="/usr/src/myapp/bin/vault-plugin-auth-jwt.${TARGET_VERSION}"

mkdir -p "${HASHI_DIR}"
cd "${HASHI_DIR}"

git clone https://github.com/tuono/vault-plugin-auth-jwt.git
cd vault-plugin-auth-jwt
git checkout policy_claim

# all_tags=$(git tag -l --sort=-version:refname "*tuono*")
# latest=$(git tag -l --sort=-version:refname "*tuono*" | head -n 1)

make bootstrap
make dev
make test

mkdir -p /usr/src/myapp/bin
mv bin/vault-plugin-auth-jwt "${RESULT}"

# Gemfury does not yet support package pushes for golang
# they only support source pushes via git.
# if ${CI}; then
#   curl -F package=@${RESULT} https://${FURY_TOKEN}@go-proxy.fury.io/tuono/
# fi
