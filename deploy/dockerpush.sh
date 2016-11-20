#!/bin/bash

COMMIT_ID=`git log --format="%H" -n 1` 

docker login -e $DOCKER_EMAIL -u $DOCKER_USER -p $DOCKER_PASS
docker push ${DOCKER_USER}/hj_app:$COMMIT_ID
