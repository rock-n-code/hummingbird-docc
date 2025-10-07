## ===----------------------------------------------------------------------===
## 
## This source file is part of the Hummingbird DocC open source project
## 
## Copyright (c) 2025 Röck+Cöde VoF. and the Hummingbird DocC project authors
## Licensed under Apache license v2.0
## 
## See LICENSE for license information
## See CONTRIBUTORS for the list of Hummingbird DocC project authors
##
## SPDX-License-Identifier: Apache-2.0
## 
## ===----------------------------------------------------------------------===

# ENVIRONMENT VARIABLES

environment ?= .env

include $(environment)
export $(shell sed 's/=.*//' $(environment))

# LIBRARY

lib-build: ## Builds the library
	@swift build \
		--target $(SPM_LIBRARY_TARGET)

lib-release: ## Releases the library
	@swift build \
		--target $(SPM_LIBRARY_TARGET) \
		--configuration release

lib-sample: ## Runs the sample app of the library
	@swift run \
		--configuration release \
		--disable-sandbox

lib-test: ## Runs the unit tests for the library
	@swift test \
		--disable-xctest \
		--enable-code-coverage \
		--enable-swift-testing \
		--parallel 

# SWIFT PACKAGE MANAGER

pkg-clean: ## Deletes built SPM artifacts of the package
	@swift package clean

pkg-reset: ## Resets the complete SPM cache/build folder of the package
	@swift package reset

pkg-pristine: pkg-clean pkg-reset ## Deletes all built artifacts, caches, and documentations of the package
	@rm -drf $(DOCC_ARCHIVE_OUTPUT)
	@rm -drf $(DOCC_GITHUB_OUTPUT)

pkg-outdated: ## Lists the SPM package dependencies that can be updated
	@swift package update --dry-run

pkg-update: ## Updates the SPM package dependencies
	@swift package update
	
# DOCUMENTATION

doc-generate: doc-generate-archive doc-generate-github ## Generates the library documentation for both Github and Xcode

doc-generate-archive: ## Generates the library documentation archive for Xcode
	@swift package \
		--allow-writing-to-directory $(DOCC_ARCHIVE_OUTPUT) \
		generate-documentation \
		--target $(SPM_LIBRARY_TARGET) \
		--hosting-base-path $(DOCC_ARCHIVE_BASE_PATH) \
		--output-path $(DOCC_ARCHIVE_OUTPUT) \
		--symbol-graph-minimum-access-level $(DOCC_CONFIG_MINIMUM_ACCESS_LEVEL) \
		--include-extended-types \
		--enable-inherited-docs

doc-generate-github: ## Generates the library documentation for Github
	@swift package \
		--allow-writing-to-directory $(DOCC_GITHUB_OUTPUT) \
		generate-documentation \
		--target $(SPM_LIBRARY_TARGET) \
		--disable-indexing \
		--transform-for-static-hosting \
		--hosting-base-path $(DOCC_GITHUB_BASE_PATH) \
		--output-path $(DOCC_GITHUB_OUTPUT) \
		--symbol-graph-minimum-access-level $(DOCC_CONFIG_MINIMUM_ACCESS_LEVEL) \
		--include-extended-types \
		--enable-inherited-docs

doc-preview: ## Previews the library documentation in Safari
	@open -a safari $(DOCC_CONFIG_PREVIEW_URL)
	@swift package \
		--disable-sandbox \
		preview-documentation \
		--target $(SPM_LIBRARY_TARGET) \
		--symbol-graph-minimum-access-level $(DOCC_CONFIG_MINIMUM_ACCESS_LEVEL) \
		--include-extended-types \
		--enable-inherited-docs

# IDE

ide-xcode: ## Opens this package with Xcode
	@open -a Xcode Package.swift

ide-vscode: ## Opens this package with Visual Studio Code
	@code .

# HELP

# Output the documentation for each of the defined tasks when `help` is called.
# Reference: https://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
.PHONY: help

help: ## Prints the written documentation for all the defined tasks
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

.DEFAULT_GOAL := help
