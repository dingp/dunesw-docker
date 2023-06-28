#!/bin/bash

if [ "$#" == "0" ]; then
  echo "Usage: make_dunesw_docker_image.sh dunesw_version_number, e.g. v09_75_02d00"
  exit 1
fi

VERSION=$1

docker run --rm -v $PWD:/scratch -v /cvmfs:/cvmfs dingpf/sl7 /scratch/get_dirs.sh dunesw ${VERSION} -q e20:prof
mkdir -p cvmfs
./copy_cvmfs_dir.py dirs.txt cvmfs


VERSION=${VERSION//_/-}
cat <<\EOF >> Dockerfile_dingpf:dunesw:${VERSION}
FROM dingpf/sl7:latest

ADD cvmfs /cvmfs
ADD env.sh /env.sh

ENTRYPOINT ["/bin/bash"]
EOF

./build.sh Dockerfile_dingpf:dunesw:${VERSION}

echo "You can now push the docker image to dockerhub"
