# Generation of plain Makefiles using --plain option

am_output_plain_makefile=yes
. test-init.sh

cat >> configure.ac << 'END'
AC_PROG_CC
AX_CONFIG_INCLUDE()
AC_OUTPUT
END

cat >> Makefile.am << 'END'
AUTOMAKE_OPTIONS = foreign
noinst_PROGRAMS = hello
hello_SOURCES = hello.c second.c rhubarb.h beetroot.h
EXTRA_DIST = config.mk.in
DISTCLEANFILES = config.mk
END

cat >> hello.c << 'END'
#include <stdio.h>
#include "beetroot.h"

int main (void)
{
printf("Hello, world\n");
}
END

touch second.c

cat >> beetroot.h << 'END'
#include "rhubarb.h"
END

touch rhubarb.h

$ACLOCAL
$AUTOCONF
# Use am_original_AUTOMAKE to avoid the -Werror option, which makes
# nested variable expansions an error
$am_original_AUTOMAKE -a --plain

$MAKE distcheck

:
