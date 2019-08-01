BIN = hwcpp
MODULES =
SHARED  = 

CSRCS =

BINDIR = /usr/bin
MODDIR = 
DESTDIR := /

CC := g++
INCLUDES := 
WARN := -Wall -Wextra -Werror
HARDEN := -fstack-protector -U_FORTIFY_SOURCE -D_FORTIFY_SOURCE=2
DEFINES := -D_BSD_SOURCE=1 -D_DEFAULT_SOURCE=1 -D_XOPEN_SOURCE=700
CFLAGS := $(WARN) -O2 -fPIC -std=c99 -pedantic $(HARDEN) $(DEFINES)

.SUFFIXES: .c .o .so
.PHONY: clean tidy

all: $(BIN) $(MODULES) $(SHARED)

install: $(BIN) $(MODULES)
	for f in $(BIN); do \
		install -D -m 0755 $$f $(DESTDIR)$(BINDIR)/$$f; \
	done
	for f in $(MODULES); do \
		install -D -m 0644 $$f $(DESTDIR)$(MODDIR)/modules/$$f; \
	done
	for f in $(SHARED); do \
		install -D -m 0644 $$f $(DESTDIR)$(LUAPATH)/db2cfg/$$f; \
	done

.o.so:
	$(CC) $(LDFLAGS) -o $@ $< $(LDLIBS)
	chmod 644 $@

.c.o:
	$(CC) $(CFLAGS) $(INCLUDES) -o $@ -c $<

clean:
	rm -f $(BIN) *.o *.so

tidy: $(CSRCS)
	clang-tidy $^ -- $(CFLAGS) $(INCLUDES)

