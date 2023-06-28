#!/bin/bash

DFile=$1

REG=""
#REG=registry.services.nersc.gov/

TTag=`echo ${DFile} | cut -d '_' -f 2`

REPO=`echo ${TTag} | cut -d ':' -f 1`
NAME=`echo ${TTag} | cut -d ':' -f 2`
VERSION=`echo ${TTag} | cut -d ':' -f 3`

echo "docker build --file --tag ${REG}${REPO}/${NAME}:${VERSION} ${PWD}"
docker build --file ${DFile} --tag ${REG}${REPO}/${NAME}:${VERSION} ${PWD}

echo "Finished building the image, use the following command to push it."
echo "docker push ${REG}${REPO}/${NAME}:${VERSION}"
