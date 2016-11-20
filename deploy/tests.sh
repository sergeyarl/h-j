#!/bin/bash

COMMIT_ID=`git log --format="%H" -n 1` &&

if [ $CIRCLE_BRANCH = 'staging' ]; then
  docker run -i --rm ${DOCKER_USER}/hj_app:$COMMIT_ID script/test
fi
