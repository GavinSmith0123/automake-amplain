#! /bin/sh
# Copyright (C) 2002-2012 Free Software Foundation, Inc.
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Check subpackage handling - top level with plain mode build system,
# subpackage with regular build system
# This should work because automake outputs based on the contents of
# AC_CONFIG_FILES and AC_CONFIG_LINKS, not on the contents of
# AC_CONFIG_SUBDIRS.
# If, however, we ever use SUBDIRS instead for what makefiles to output,
# there will be a problem if we mix styles.

am_output_plain_makefile=yes
required=cc
. test-init.sh

mkdir m4

cat >m4/foo.m4 <<'EOF'
AC_DEFUN([FOO],[
  AC_PROG_CC
  AC_OUTPUT
])
EOF

cat >>configure.ac <<'END'
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_SUBDIRS([lib])
AX_CONFIG_INCLUDE
FOO
END

cat >Makefile.am <<'EOF'
EXTRA_DIST = config.mk.in
DISTCLEANFILES = config.mk
SUBDIRS = lib
# Yes, This program is named LDADD.  So what?
bin_PROGRAMS = LDADD
LDADD_LDADD = lib/liblib.a

# It's ok to override distdir.
distdir = subpack-1

# Make sure $(distdir) and $(top_distdir) work as expected.
dist-hook:
	test -f $(distdir)/LDADD.c
	test -f $(top_distdir)/LDADD.c
EOF

cat >LDADD.c <<'EOF'
int lib (void);
int main (void)
{
  return lib ();
}
EOF

mkdir lib
mkdir lib/src

cat >lib/configure.ac <<'EOF'
AC_INIT([lib], [2.3])
AM_INIT_AUTOMAKE
AC_CONFIG_MACRO_DIR([../m4])
AM_PROG_AR
AC_PROG_RANLIB
AC_CONFIG_HEADERS([config.h:config.hin])
AC_CONFIG_FILES([Makefile])
FOO
EOF

cat >lib/Makefile.am <<'EOF'
noinst_LIBRARIES = liblib.a
liblib_a_SOURCES = src/x.c

dist-hook:
	test ! -f $(distdir)/LDADD.c
	test -f $(top_distdir)/LDADD.c
	test -f $(distdir)/src/x.c
	test ! -f $(top_distdir)/src/x.c
EOF

cat >lib/src/x.c <<'EOF'
#include <config.h>
int lib (void)
{
  return 0;
}
EOF

$ACLOCAL
$AUTOCONF
$am_original_AUTOMAKE --foreign -a --plain -Wno-override

cd lib
$ACLOCAL
$FGREP 'm4_include([../m4/foo.m4])' aclocal.m4
$AUTOCONF
$AUTOHEADER
$AUTOMAKE -Wno-override --add-missing
cd ..

$MAKE
$MAKE distcheck
test ! -e subpack-1 # Make sure distcheck cleans up after itself.
test -f subpack-1.tar.gz

: