.POSIX:

CONFIGFILE = config.mk
include $(CONFIGFILE)


all: exec-as test

.o:
	$(CC) -o $@ $< $(LDFLAGS)

.c.o:
	$(CC) -c -o $@ $< $(CFLAGS) $(CPPFLAGS)

check: exec-as test
	test "$$(./exec-as ./test 1 2 3)"  = "1,3"

install: exec-as
	mkdir -p -- "$(DESTDIR)$(PREFIX)/bin"
	mkdir -p -- "$(DESTDIR)$(MANPREFIX)/man1"
	cp -- exec-as "$(DESTDIR)$(PREFIX)/bin/"
	cp -- exec-as.1 "$(DESTDIR)$(MANPREFIX)/man1/"

uninstall:
	-rm -f -- "$(DESTDIR)$(PREFIX)/bin/exec-as"
	-rm -f -- "$(DESTDIR)$(MANPREFIX)/man1/exec-as.1"

clean:
	-rm -f -- exec-as test *.o *.su

.SUFFIXES:
.SUFFIXES: .o .c

.PHONY: all check install uninstall clean
