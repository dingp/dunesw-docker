# Scripts to build a docker image containing `dunesw` and its dependencies


To run the scripts, do

```
   ./make_dunesw_docker_image.sh v09_75_02d00
```

It requires the build node to have cvmfs available.


The docker image is based on SL7. The default qualifier used for `dunesw` is `e20:prof`.

If changing the qualifier, or the default base image (AL8 or AL9), one may need to change the filtering list in `copy_cvmfs_dir.py` to exclude/include proper UPS directories.

There are several UPS products which do not have `<PROD_DIR>` set. They are handled individually in `get_dirs.sh`. 

The script `make_dunesw_docker_image.sh` is the master script to run. 
1. It calls `get_dirs.sh`, which produces a `dirs.txt` file showing which directories from cvmfs will be used;
2. `copy_cvmfs_dir.py` will use `dirs.txt` and copy contents from cvmfs to a local `./cvmfs` directory. It contains a filter list, so only the relevant UPS products `flavor` is copied over;
3. An `env.sh` file will be generated. `modify_env.py` is the script used to clean it up.
4. A dockerfile will also be generated. The `build.sh` will use that to build a docker image. The image will contain `/cvmfs` and `/env.sh`. When running the image, one should just do `source /env.sh` to set things up, and should avoid doing the usual `source <cvmfs_path>/setup_dune.sh; setup dunesw <version> -q <qualifier>`. 
