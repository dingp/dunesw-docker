#!/usr/bin/env python

import os
import sys
import shutil
import errno

# [[ -z "$GIT_DIR" ]] &&  export GIT_DIR=${GIT_HOME};
# for i in `ups active | awk '{print $1}'| tr [a-z] [A-Z]`; \
# do j=${i}_DIR; echo ${!j}; done| tee dirs.txt

ignore_p = shutil.ignore_patterns( '*Linux64bit+2.6*',
                                  'Darwin64bit*',
                                  'Linux*-debug',
                                  'slf7.*.debug',
                                  'slf7.x86_64.c*',
                                  'slf7.x86_64.e26*',
                                  'Linux64bit+3.10-2.17-c7-*',
                                  'Linux64bit+3.10-2.17-c14-*',
                                  'Linux64bit+3.10-2.17-e26-*'
                                  )


def copyanything(src, dst):
    if os.path.exists(dst):
        print("### WARNING! destination folder exists, skipping!\n")
        return
    try:
        shutil.copytree(src, dst, symlinks=True, ignore=ignore_p)
    except OSError as exc:  # python >2.5
        if exc.errno == errno.ENOTDIR:
            shutil.copy(src, dst)
        else:
            raise
    return


def copyfile(src, dst):
    dir_name = os.path.dirname(dst)
    print("checking dir: " + dir_name)
    if not os.path.exists(dir_name):
        print("making dir: " + dir_name)
        os.makedirs(dir_name)
    shutil.copy(src, dst)
    return

# get list of dirs from input file


if len(sys.argv) != 3:
    print("usage: copy_cvmfs_dir.py list.txt dest_dir")

input_list = sys.argv[1]

dest_root_dir = sys.argv[2]

with open(input_list, 'r') as inlist:
    for iline in inlist:
        isrc = iline.strip()
        if not isrc:
            continue
        idest = os.path.join(dest_root_dir, os.path.relpath(isrc, '/cvmfs'))
        print("{} --> {}".format(isrc, idest))
        if os.path.isdir(isrc):
            copyanything(isrc, idest)
        if os.path.isfile(isrc):
            copyfile(isrc, idest)
