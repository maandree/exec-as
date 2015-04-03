# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


# The package path prefix, if you want to install to another root, set DESTDIR to that root
PREFIX ?= /usr
# The command path excluding prefix
BIN ?= /bin
# The resource path excluding prefix
DATA ?= /share
# The command path including prefix
BINDIR ?= $(PREFIX)$(BIN)
# The resource path including prefix
DATADIR ?= $(PREFIX)$(DATA)
# The generic documentation path including prefix
DOCDIR ?= $(DATADIR)/doc
# The info manual documentation path including prefix
INFODIR ?= $(DATADIR)/info
# The license base path including prefix
LICENSEDIR ?= $(DATADIR)/licenses

# The name of the command as it should be installed
COMMAND ?= exec-as
# The name of the package as it should be installed
PKGNAME ?= exec-as

# Optimisation settings for C code compilation
OPTIMISE ?= -Og -g
# Warnings settings for C code compilation
WARN = -Wall -Wextra -Wdouble-promotion -Wformat=2 -Winit-self -Wmissing-include-dirs            \
       -Wtrampolines -Wfloat-equal -Wshadow -Wmissing-prototypes -Wmissing-declarations          \
       -Wredundant-decls -Wnested-externs -Winline -Wno-variadic-macros -Wsync-nand              \
       -Wunsafe-loop-optimizations -Wcast-align -Wstrict-overflow -Wdeclaration-after-statement  \
       -Wundef -Wbad-function-cast -Wcast-qual -Wwrite-strings -Wlogical-op -Waggregate-return   \
       -Wstrict-prototypes -Wold-style-definition -Wpacked -Wvector-operation-performance        \
       -Wunsuffixed-float-constants -Wsuggest-attribute=const -Wsuggest-attribute=noreturn       \
       -Wsuggest-attribute=pure -Wsuggest-attribute=format -Wnormalized=nfkc -Wconversion        \
       -fstrict-aliasing -fstrict-overflow -fipa-pure-const -ftree-vrp -fstack-usage             \
       -funsafe-loop-optimizations -pedantic
# The C standard for C code compilation
STD = c99



# Build rules

.PHONY: default
default: command

.PHONY: all
all: command

.PHONY: command
command: bin/exec-as


bin/exec-as: obj/exec-as.o
	@mkdir -p bin
	$(CC) $(WARN) $(OPTIMISE) $(LDFLAGS) -o $@ $^

obj/%.o: src/%.c
	@mkdir -p obj
	$(CC) -std=$(STD) $(WARN) $(OPTIMISE) $(CFLAGS) $(CPPFLAGS) -c -o $@ $<



# Install rules

.PHONY: install
install: install-base

.PHONY: install-base
install-base: install-command install-license

.PHONY: install-command
install-command: bin/exec-as
	install -dm755            -- "$(DESTDIR)$(BINDIR)"
	install -m755 bin/exec-as -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"

.PHONY: install-license
install-license: COPYING LICENSE
	install -dm755   -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 $^ -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"



# Uninstall rules

.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"



# Clean rules

.PHONY: clean
clean:
	-rm -r bin obj

