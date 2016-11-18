#!/bin/bash

# deploy the project to staging server
# start the application

dep_host='176.9.143.59'
dep_port='33222'

commit_id=`git log --format="%H" -n 1`

docker_user=${DOCKER_USER}
docker_pass=${DOCKER_PASS}

appname='testapp'

echo "Check if $appname is running."
ssh -p $dep_port root@$dep_host "docker ps |grep -i $appname"

if [[ $? -eq 0 ]]; then
  echo "Attempt to stop $appname."
  ssh -p $dep_port root@$dep_host "docker kill $appname"
  
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Unable to kill $appname"
    exit 1
  fi 
fi

echo "Check if $appname container is not removed"
ssh  -p $dep_port root@$dep_host "docker ps --all|grep -i $appname"

if [[ $? -eq 0 ]]; then
  echo "Remove $appname container"
  ssh -p $dep_port root@$dep_host "docker rm $appname"
  
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Unable to remove $appname"
    exit 1
  fi
fi

echo "Start $appname container"
ssh -p $dep_port root@$dep_host <<EOF
  docker run --name $appname -d -p 5000:5000 ${docker_user}/hj_app:$commit_id 
EOF

if [[ $? -ne 0 ]]; then
  echo "ERROR: Unable to start $appname"
  exit 1
fi
