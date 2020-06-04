#
# Copyright (C) 2020 Tuono, Inc.
# All Rights Reserved
#

PROJECT := tuono-vault-jwt-plugin

.PHONY: clean jwt-plugin

clean:
	@rm -rf jwt-plugin/bin/*

jwt-plugin:
	jwt-plugin/build.sh
