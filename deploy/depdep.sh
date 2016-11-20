#!/bin/bash

COMMIT_ID=`git log --format="%H" -n 1`

if [ $CIRCLE_BRANCH = 'staging' ]; then
  docker info
  docker build --rm=false -t ${DOCKER_USER}/hj_app:$COMMIT_ID . ;
fi
