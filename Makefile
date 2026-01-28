# AIESDA Automation Makefile
# Targets: install, clean, test

# Default message if none is provided
MSG ?= "routine_update"
# Archive local changes with a message
# Usage: make archive MSG="your_message_here"

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

archive:
	@bash jobs/archive_pkg.sh -m $(MSG)

reinstall: 
	clean install

update: 
	sync reinstall

release: 
	bump archive
