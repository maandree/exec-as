.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)

all: exec-as test

.o:
	$(CC) -o $@ $^ $(LDFLAGS)

.c.o:
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

check: exec-as test
	test "$$(./exec-as ./test)"  = ""
	test "$$(./exec-as ./test 1 2 3)"  = "1,3"

install:
	mkdir -p -- "$(DESTDIR)$(PREFIX)/bin"
	mkdir -p -- "$(DESTDIR)$(MANPREFIX)/man1"
	mkdir -p -- "$(DESTDIR)$(PREFIX)/share/licenses/exec-as"
	cp -- exec-as "$(DESTDIR)$(PREFIX)/bin/"
	cp -- exec-as.1 "$(DESTDIR)$(MANPREFIX)/man1/"
	cp -- LICENSE "$(DESTDIR)$(PREFIX)/share/licenses/exec-as/"

uninstall:
	-rm -f -- "$(DESTDIR)$(PREFIX)/bin/exec-as"
	-rm -f -- "$(DESTDIR)$(MANPREFIX)/man1/exec-as.1"
	-rm -rf -- "$(DESTDIR)$(PREFIX)/share/licenses/exec-as"

clean:
	-rm -f -- exec-as test

.SUFFIXES: .o .c.o

.PHONY: all check install uninstall clean
