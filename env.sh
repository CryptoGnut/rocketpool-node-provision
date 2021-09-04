#!/bin/bash
ENV=${1:-dev}

unset MINER
echo "Switching to $ENV environment"
if [ "$ENV" == "vagrant" ]
then 
    MINER="vagrant-miner = ansible_host=172.19.208.1 ansible_port=2222"
    #rm inventory/hcloud.yaml 2> /dev/null
else
  if [ ! -z "$2" ]
  then
    MINER="miner = ansible_host=$2"
  fi
fi

echo "
localhost = ansible_connection=local

[miners]
$MINER

[$ENV:children]
miners

[$ENV]
localhost
" > inventory/hosts