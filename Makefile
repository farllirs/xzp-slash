# Makefile for xzp-slash

PREFIX ?= /usr
DESTDIR ?=
BINDIR = $(DESTDIR)$(PREFIX)/bin
LIBDIR = $(DESTDIR)$(PREFIX)/lib/slash
SHAREDIR = $(DESTDIR)$(PREFIX)/share/slash
ETCDIR = $(DESTDIR)/etc/slash

all:
	@echo "Nothing to build. Use 'make install' to install."

install:
	# Create directories
	mkdir -p $(BINDIR)
	mkdir -p $(LIBDIR)
	mkdir -p $(SHAREDIR)/completions
	mkdir -p $(SHAREDIR)/icons
	mkdir -p $(ETCDIR)

	# Install binaries
	install -m 755 bin/slash $(BINDIR)/slash
	install -m 755 bin/slash-daemon $(BINDIR)/slash-daemon
	install -m 755 bin/slash-health $(BINDIR)/slash-health
	install -m 755 bin/slash-run $(BINDIR)/slash-run
	install -m 755 bin/slash-task $(BINDIR)/slash-task

	# Install library
	install -m 644 lib/slash.py $(LIBDIR)/slash.py
	install -m 644 lib/slash-env.sh $(LIBDIR)/slash-env.sh

	# Install completions
	install -m 644 completions/bash_widget.sh $(SHAREDIR)/completions/
	install -m 644 completions/zsh_widget.zsh $(SHAREDIR)/completions/
	install -m 644 completions/pkg_completion.zsh $(SHAREDIR)/completions/

	# Install icons
	cp -r icons/* $(SHAREDIR)/icons/

	# Install default config (don't overwrite if exists)
	test -f $(ETCDIR)/commands.json || install -m 644 config/commands.json $(ETCDIR)/
	test -f $(ETCDIR)/settings.json || install -m 644 config/settings.example.json $(ETCDIR)/settings.json
	test -f $(ETCDIR)/tool_registry.json || install -m 644 config/tool_registry.json $(ETCDIR)/

uninstall:
	rm -f $(BINDIR)/slash
	rm -f $(BINDIR)/slash-daemon
	rm -f $(BINDIR)/slash-health
	rm -f $(BINDIR)/slash-run
	rm -f $(BINDIR)/slash-task
	rm -rf $(LIBDIR)
	rm -rf $(SHAREDIR)
	# We leave /etc/slash to avoid losing user config unless specified

.PHONY: all install uninstall
