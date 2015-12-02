# Copying and distribution of this file, with or without modification,
# are permitted in any medium without royalty provided the copyright
# notice and this notice are preserved.  This file is offered as-is,
# without any warranty.


# The package path prefix, if you want to install to another root, set DESTDIR to that root
PREFIX = /usr
# The command path excluding prefix
BIN = /bin
# The resource path excluding prefix
DATA = /share
# The command path including prefix
BINDIR = $(PREFIX)$(BIN)
# The resource path including prefix
DATADIR = $(PREFIX)$(DATA)
# The generic documentation path including prefix
DOCDIR = $(DATADIR)/doc
# The info manual documentation path including prefix
INFODIR = $(DATADIR)/info
# The man page documentation path including prefix
MANDIR = $(DATADIR)/man
# The man page section 1 path including prefix
MAN1DIR = $(MANDIR)/man1
# The license base path including prefix
LICENSEDIR = $(DATADIR)/licenses

# The name of the command as it should be installed
COMMAND = exec-as
# The name of the package as it should be installed
PKGNAME = exec-as

# Optimisation settings for C code compilation
OPTIMISE = -Og -g
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
default: base info

.PHONY: all
all: base doc

.PHONY: base
base: command

.PHONY: command
command: bin/exec-as

bin/exec-as: obj/exec-as.o
	@mkdir -p bin
	$(CC) $(WARN) $(OPTIMISE) -o $@ $^ $(LDFLAGS)

obj/%.o: src/%.c
	@mkdir -p obj
	$(CC) -std=$(STD) $(WARN) $(OPTIMISE) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

.PHONY: doc
doc: info pdf dvi ps

.PHONY: info
info: bin/exec-as.info
bin/%.info: doc/info/%.texinfo
	@mkdir -p bin
	$(MAKEINFO) $<
	mv $*.info $@

.PHONY: pdf
pdf: bin/exec-as.pdf
bin/%.pdf: doc/info/%.texinfo
	@! test -d obj/pdf || rm -rf obj/pdf
	@mkdir -p bin obj/pdf
	cd obj/pdf && texi2pdf ../../"$<" < /dev/null
	mv obj/pdf/$*.pdf $@

.PHONY: dvi
dvi: bin/exec-as.dvi
bin/%.dvi: doc/info/%.texinfo
	@! test -d obj/dvi || rm -rf obj/dvi
	@mkdir -p bin obj/dvi
	cd obj/dvi && $(TEXI2DVI) ../../"$<" < /dev/null
	mv obj/dvi/$*.dvi $@

.PHONY: ps
ps: bin/exec-as.ps
bin/%.ps: doc/info/%.texinfo
	@! test -d obj/ps || rm -rf obj/ps
	@mkdir -p bin obj/ps
	cd obj/ps && texi2pdf --ps ../../"$<" < /dev/null
	mv obj/ps/$*.ps $@



# Install rules

.PHONY: install
install: install-base install-info install-man

.PHONY: install-all
install-all: install-base install-doc

.PHONY: install-base
install-base: install-command install-copyright

.PHONY: install-command
install-command: bin/exec-as
	install -dm755            -- "$(DESTDIR)$(BINDIR)"
	install -m755 bin/exec-as -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"

.PHONY: install-copyright
install-copyright: install-copying install-license

.PHONY: install-copying
install-copying:
	install -dm755        -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 COPYING -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

.PHONY: install-license
install-license:
	install -dm755        -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	install -m644 LICENSE -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"

.PHONY: install-doc
install-doc: install-info install-pdf install-dvi install-ps install-man

.PHONY: install-info
install-info: bin/exec-as.info
	install -dm755   -- "$(DESTDIR)$(INFODIR)"
	install -m644 $< -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"

.PHONY: install-pdf
install-pdf: bin/exec-as.pdf
	install -dm755   -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"

.PHONY: install-dvi
install-dvi: bin/exec-as.dvi
	install -dm755   -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"

.PHONY: install-ps
install-ps: bin/exec-as.ps
	install -dm755   -- "$(DESTDIR)$(DOCDIR)"
	install -m644 $< -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"

.PHONY: install-man
install-man:
	install -dm755                  -- "$(DESTDIR)$(MAN1DIR)"
	install -m644 doc/man/exec-as.1 -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"



# Uninstall rules

.PHONY: uninstall
uninstall:
	-rm -- "$(DESTDIR)$(BINDIR)/$(COMMAND)"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/COPYING"
	-rm -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)/LICENSE"
	-rmdir -- "$(DESTDIR)$(LICENSEDIR)/$(PKGNAME)"
	-rm -- "$(DESTDIR)$(INFODIR)/$(PKGNAME).info"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).pdf"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).dvi"
	-rm -- "$(DESTDIR)$(DOCDIR)/$(PKGNAME).ps"
	-rm -- "$(DESTDIR)$(MAN1DIR)/$(COMMAND).1"



# Clean rules

.PHONY: clean
clean:
	-rm -r bin obj

