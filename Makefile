# AIESDA Automation Makefile
# Targets: install, clean, test

.PHONY: install clean test help

# Default target
help:
	@echo "AIESDA Management Commands:"
	@echo "  make install  - Run the unified installer (detects WSL/HPC)"
	@echo "  make clean    - Run the surgical uninstaller for the current version"
	@echo "  make test     - Run post-installation verification"

# Use this to verify the version before a build
version:
	@echo "Current Target: $$(cat VERSION)"

sync:
	@bash jobs/update_pkg.sh

install:
	@bash jobs/install.sh

clean:
	@bash jobs/remove.sh $$(cat VERSION)

test:
	@bash jobs/aiesda-dev-cycle-test.sh

bump:
	@bash jobs/bump_version.sh

reinstall: 
	clean install

update: 
	sync reinstall
