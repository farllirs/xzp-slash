# Makefile for xzp-slash

PREFIX ?= /usr
DESTDIR ?=
SUDO ?= 
BINDIR = $(DESTDIR)$(PREFIX)/bin
LIBDIR = $(DESTDIR)$(PREFIX)/lib/slash
SHAREDIR = $(DESTDIR)$(PREFIX)/share/slash

# Detect if we are in Termux for ETCDIR
ifeq ($(shell [ -d /data/data/com.termux ] && echo termux),termux)
	ETCDIR = $(DESTDIR)$(PREFIX)/etc/slash
else
	ETCDIR = $(DESTDIR)/etc/slash
endif

all:
	@echo "Nothing to build. Use 'make install' to install."

install:
	# Create directories
	$(SUDO) mkdir -p $(BINDIR)
	$(SUDO) mkdir -p $(LIBDIR)
	$(SUDO) mkdir -p $(SHAREDIR)/completions
	$(SUDO) mkdir -p $(SHAREDIR)/icons
	$(SUDO) mkdir -p $(ETCDIR)

	# Install binaries
	$(SUDO) install -m 755 bin/slash $(BINDIR)/slash
	$(SUDO) install -m 755 bin/slash-daemon $(BINDIR)/slash-daemon
	$(SUDO) install -m 755 bin/slash-health $(BINDIR)/slash-health
	$(SUDO) install -m 755 bin/slash-run $(BINDIR)/slash-run
	$(SUDO) install -m 755 bin/slash-task $(BINDIR)/slash-task

	# Install library
	$(SUDO) install -m 644 lib/slash.py $(LIBDIR)/slash.py
	$(SUDO) install -m 644 lib/slash-env.sh $(LIBDIR)/slash-env.sh

	# Install completions
	$(SUDO) install -m 644 completions/bash_widget.sh $(SHAREDIR)/completions/
	$(SUDO) install -m 644 completions/zsh_widget.zsh $(SHAREDIR)/completions/
	$(SUDO) install -m 644 completions/pkg_completion.zsh $(SHAREDIR)/completions/

	# Install icons
	$(SUDO) cp -r icons/* $(SHAREDIR)/icons/

	# Install default config (don't overwrite if exists)
	$(SUDO) test -f $(ETCDIR)/commands.json || $(SUDO) install -m 644 config/commands.json $(ETCDIR)/
	$(SUDO) test -f $(ETCDIR)/settings.json || $(SUDO) install -m 644 config/settings.example.json $(ETCDIR)/settings.json
	$(SUDO) test -f $(ETCDIR)/tool_registry.json || $(SUDO) install -m 644 config/tool_registry.json $(ETCDIR)/

uninstall:
	$(SUDO) rm -f $(BINDIR)/slash
	$(SUDO) rm -f $(BINDIR)/slash-daemon
	$(SUDO) rm -f $(BINDIR)/slash-health
	$(SUDO) rm -f $(BINDIR)/slash-run
	$(SUDO) rm -f $(BINDIR)/slash-task
	$(SUDO) rm -rf $(LIBDIR)
	$(SUDO) rm -rf $(SHAREDIR)

.PHONY: all install uninstall
