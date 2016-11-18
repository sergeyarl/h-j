#!/bin/bash

# deploy the project to staging server
# start the application

dep_host='176.9.143.59'
dep_port='33222'
commit_id=`git log --format="%H" -n 1`

docker_user=${DOCKER_USER}
docker_pass=${DOCKER_PASS}

ssh -p $dep_port root@$dep_host "docker ps |grep -i testapp"

if [[ $? -eq 0 ]]; then
  ssh -p $dep_port root@$dep_host "docker kill testapp"
  
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Unable to kill testapp"
    exit 1
  fi 
fi

ssh  -p $dep_port root@$dep_host "docker ps --all|grep -i testapp"

if [[ $? -eq 0 ]]; then
  ssh -p $dep_port root@$dep_host "docker rm testapp"
  
  if [[ $? -ne 0 ]]; then
    echo "ERROR: Unable to remove testapp"
    exit 1
  fi
fi

ssh -p $dep_port root@$dep_host <<EOF
  docker run --name testapp -d -p 5000:5000 ${docker_user}/hj_app:$commit_id 
EOF

if [[ $? -ne 0 ]]; then
  echo "ERROR: Unable to start testapp"
  exit 1
fi
