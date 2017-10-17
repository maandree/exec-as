/* See LICENSE file for copyright and license details. */
#include <errno.h>
#include <stdio.h>
#include <string.h>
#include <unistd.h>


int
main(int argc, char *argv[])
{
	if (argc < 2) {
		fprintf(stderr, "usage: %s command [argv0 [arg ...]]\n", argc ? argv[0] : "exec-as");
	} else {
		execvp(argv[1], &argv[2]);
		fprintf(stderr, "%s: execvp %s: %s\n", argv[0], argv[1], strerror(errno));
	}
	return 138;
}
