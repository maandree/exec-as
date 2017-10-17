/* See LICENSE file for copyright and license details. */
#include <stdio.h>

int
main(int argc, char *argv[])
{
	if (argc)
		printf("%s,%i\n", argv[0], argc);
	return 0;
}
