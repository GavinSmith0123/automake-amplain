# Create config.mk.in in source tree. 
AC_DEFUN([_AX_CONFIG_INCLUDE],
[for ac_file in $@; do
  t=$srcdir/$ac_file.in
  d=$srcdir/$(dirname $ac_file)/dir.mk.in
  rm -f $t $d
  
  for ac_var in $ac_subst_vars; do
   eval am_var=am_subst_notmake_\$ac_var
   eval am_var_val=\$$am_var 
   if test -n "$am_var_val"; then :; else
     echo $ac_var = \@$ac_var\@ >> $t
   fi
  done
  # These variables are substituted within config.status
  # on a Makefile-by-Makefile basis.
  for var in \
    top_builddir top_build_prefix \
    srcdir abs_srcdir top_srcdir abs_top_srcdir \
    builddir abs_builddir abs_top_builddir; do
    echo "$var = @$var@" >> $d
  done
  echo am__aux_dir = $am_aux_dir >> $d
done
])

AC_DEFUN([AX_CONFIG_INCLUDE],
[AC_CONFIG_COMMANDS_PRE([_AX_CONFIG_INCLUDE($@)])
# This will cause automake to generate rebuild rules
AC_CONFIG_FILES($@)
for ac_file in $@; do
  dir_mk_name=$(dirname $ac_file)/dir.mk
  AC_CONFIG_FILES([$dir_mk_name])
done
])

