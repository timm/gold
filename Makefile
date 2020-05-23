.PHONY: test help install mac inmac inbase headers

help: ## help
	@bash etc/help.sh $(MAKEFILE_LIST)

test: ## run unit tests
	@cd test; sh all.sh

install: mac chmod ## install

mac    : inmac inbase ; ## install to mac
inmac  :              ; @brew update
inbase :              ; @sh etc/brew.sh gawk 

headers: ## reset .md headers, except in doc/etc/doc
	@find . -name '*.md' | bash etc/headers.sh
