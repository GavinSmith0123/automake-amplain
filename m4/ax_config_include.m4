AC_DEFUN([AX_CONFIG_INCLUDE],
[# Create config.mk.in in source tree 
for ac_file in $@; do
  t=$srcdir/$ac_file.in
  rm -f $t
  
  for ac_var in $ac_subst_vars; do
   eval am_var=am_subst_notmake_\$ac_var
   eval am_var_val=\$$am_var 
   if test -n "$am_var_val"; then :; else
     echo $ac_var = \@$ac_var\@ >> $t
   fi
  done
  for var in \
    abs_top_srcdir abs_top_builddir; do
    echo "$var = @$var@" >> $t
  done
  # @srcdir@ is path from top_builddir to top_srcdir provided
  # config.mk is in top_builddir
  echo "relative_src_path = @srcdir@" >> $t
  # Analagous to top_build_prefix
  echo "top_src_prefix = @srcdir@/" >> $t
done
dnl Prevent automake from generating rebuild rules for config.mk by
dnl passing "config.mk" to AC_CONFIG_FILES indirectly
ac_config_mk_location=config.mk
dnl Third option is needed otherwise config.status doesn't work properly.
dnl See http://lists.gnu.org/archive/html/bug-autoconf/2008-08/msg00029.html
AC_CONFIG_FILES([$ac_config_mk_location], [], [ac_config_mk_location=$ac_config_mk_location])
])

