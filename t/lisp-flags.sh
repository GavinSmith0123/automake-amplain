#! /bin/sh
# Copyright (C) 2003-2013 Free Software Foundation, Inc.
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

# Elisp byte-compilation honours AM_ELCFLAFS and ELCFLAGS.

. test-init.sh

# Don't get fooled when running as an Emacs subprocess.  This is
# for the benefit of the "make -e" invocation below.
unset EMACS

cat > Makefile.am << 'EOF'
lisp_LISP = foo.el
AM_ELCFLAGS = __am_elcflags__
EOF

cat >> configure.ac << 'EOF'
AM_PATH_LISPDIR
AC_OUTPUT
EOF

$ACLOCAL
$AUTOCONF
$AUTOMAKE --add-missing

./configure EMACS='echo >$@' --with-lispdir="$(pwd)/unused"

: > foo.el
ELCFLAGS='__usr_elcflags__' $MAKE -e
grep '__am_elcflags__.*__usr_elcflags__' foo.elc

:
