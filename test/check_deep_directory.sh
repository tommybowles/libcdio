#!/bin/sh
#   Copyright (C) 2020 Pete Batard <pete@akeo.ie>
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Tests Rock Ridge deep directories (via iso-info and iso-read). 

if test -z "$srcdir" ; then
  srcdir=`pwd`
fi

if test "X$top_builddir" = "X" ; then
  top_builddir=`pwd`/..
fi

. ${top_builddir}/test/check_common_fn

if test ! -x ../src/iso-info ; then
  exit 77
fi

if test ! -x ../src/iso-read ; then
  exit 77
fi

BASE=`basename $0 .sh`

fname=deep_directory

# File listing
iso_image="${srcdir}/data/deep-directory.iso"
opts="--no-header --quiet -l ${iso_image}"
test_iso_info "$opts" ${fname}.dump ${srcdir}/${fname}.right
RC=$?
check_result $RC 'Deep directory listing test' "$ISO_INFO $opts"

# File dump and comparison
opts="--ignore --image ${iso_image} --extract 1/2/3/4/5/6/7/8/8.txt"
test_iso_read "$opts" ${fname} ${srcdir}/data/deep_directory1_file
RC=$?
check_result $RC 'Deep directory read test level 8' "$ISO_READ $opts"

opts="--ignore --image ${iso_image} --extract 1/2/3/4/5/6/7/8/9/10/11/12/13/14/14.txt"
test_iso_read "$opts" ${fname} ${srcdir}/data/deep_directory2_file
RC=$?
check_result $RC 'Deep directory read test level 14' "$ISO_READ $opts"

exit $RC
