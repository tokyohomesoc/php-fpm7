#!/bin/bash

TAG=${TAG:-$1}
strDIR=`basename $PWD`
IMAGE=foxboxsnet/$strDIR:${TAG}
echo ${IMAGE}
git pull

sleep 10s

docker rm `docker ps -a -q`	> /dev/null
docker images | grep none | awk '{print $3}' | xargs docker rmi	> /dev/null


cd $(dirname $0)
docker build --no-cache -t ${IMAGE} .

docker stop test	> /dev/null
docker rm test		> /dev/null
../run.sh ${IMAGE}