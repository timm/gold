.PHONY: test help install mac inmac inbase headers gawk

help: ## help
	@bash etc/help.sh $(MAKEFILE_LIST)

test: ## run unit tests
	@cd test; sh all.sh


install: mac chmod ## install

gawk: ## Unix install for gawk. Takes about 2 minute
	@wget -O /tmp/gawk.tar.gz https://ftp.gnu.org/gnu/gawk/gawk-5.1.0.tar.gz
	@cd /tmp; tar xzf gawk.tar.gz
	@cd gawk-5.1.0; ./configure; sudo make; sudo make install
	@gawk -W version | head -1

mac    : inmac inbase ; ## install to mac
inmac  :              ; @brew update
inbase :              ; @sh etc/brew.sh gawk 

headers: ## reset .md headers, except in doc/etc/doc
	@find . -name '*.md' | bash etc/headers.sh
