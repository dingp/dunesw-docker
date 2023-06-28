#!/bin/bash

if [ "$#" == "0" ]; then
  exit 1
fi

CMD=""
while (( "$#" )); do
  if [[ "$1" != "" ]]; then
    CMD="$CMD $1" 
  fi
  shift
done

source /cvmfs/dune.opensciencegrid.org/products/dune/setup_dune.sh >/dev/null 2>&1 

# do setup
eval "setup ${CMD}" # setup dunesw v09_75_02d00 -q e20:prof


# Fixing UPS packages with env <PROD_DIR> not set ...
if [[ ! -z "$SETUP_CIGETCERT" ]]; then
    st_array=${SETUP_CIGETCERT}
    export CIGETCERT_DIR="${st_array[5]}../prd/${st_array[0]}/${st_array[1]}"
fi

if [[ ! -z "$SETUP_GIT" ]]; then
    st0_array=(${SETUP_GIT})
    export GH_DIR="${st0_array[5]}/${st0_array[0]}/${st0_array[1]}"
fi

if [[ ! -z "$SETUP_GH" ]]; then
    st1_array=(${SETUP_GH})
    export GH_DIR="${st1_array[5]}/${st1_array[0]}/${st1_array[1]}"
fi

if [[ ! -z "$SETUP_KX509" ]]; then
    st2_array=(${SETUP_KX509})
    export KX509_DIR="${st2_array[5]}../prd/${st2_array[0]}/${st2_array[1]}"
fi

# encp is under /opt/encp, skipping it
if [[ ! -z "$SETUP_ENCP" ]]; then
    export ENCP_DIR=""
fi

# make dirs.txt
rm -f /scratch/dirs.txt
touch /scratch/dirs.txt
for i in `ups active| awk '{print $1}'| tr [a-z] [A-Z]`
do
    j=${i}_DIR
    echo ${!j} >> /scratch/dirs.txt
done

# make env file
rm -f /scratch/env_tmp.sh
rm -f /scratch/env.sh
printenv > /scratch/env_tmp.sh

# modify env file
/scratch/modify_env.py /scratch/env_tmp.sh > /scratch/env.sh

# append ups functions to env file
declare -f >> /scratch/env.sh

rm -f /scratch/env_tmp.sh
