/**
 * exec-as — A command that lets you start another command with any argv[0]
 * Copyright © 2015  Mattias Andrée (maandree@member.fsf.org)
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#include <unistd.h>
#include <stdio.h>


int main(int argc, char** argv)
{
  char* execname;
  char* file;
  int i;
  
  if (argc < 3)
    {
      fprintf(stderr, "%s: %s", argc ? argv[0] : "exec-as",
	      "Too few arguments, you need atleast "
	      "the file to run and its argv[0].");
      goto fail;
    }
  
  execname = argv[0];
  file = argv[1];
  
  for (i = 0; i < argc - 2; i++)
    argv[i] = argv[i + 2];
  argv[i] = NULL;
  
  execvp(file, argv);
  perror(execname);
 fail:
  return 138;
}
