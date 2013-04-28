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
done
# This will cause automake to generate rebuild rules for config.mk
AC_CONFIG_FILES($@)

# Handle dir.mk's
# FIXME: only do it once for each directory where an output file exists
for ac_file in $ac_config_files $ac_config_links; do
  dir_mk_name=$(dirname $(echo $ac_file | sed 's/:.*//'))/dir.mk
  AC_CONFIG_FILES([$dir_mk_name])
  d=$srcdir/$dir_mk_name.in
  rm -f $d
  touch $d
done
])

