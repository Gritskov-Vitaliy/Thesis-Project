#!/bin/bash

MASTER_HOST_IP=$(cat terraform/inventory.ini | awk '{if ($1 == "thesis-project-master" && $2 == "ansible_user=ubuntu") { print $3 }}' | cut -d= -f2)
SERVER_IP=$(cat terraform/inventory.ini | grep supplementary_addresses_in_ssl_keys | cut -d\' -f2)

mkdir ~/.kube
ssh ubuntu@$MASTER_HOST_IP mkdir /home/ubuntu/.kube
ssh ubuntu@$MASTER_HOST_IP sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
ssh ubuntu@$MASTER_HOST_IP sudo chown ubuntu:ubuntu /home/ubuntu/.kube/config
scp ubuntu@$MASTER_HOST_IP:/home/ubuntu/.kube/config  ~/.kube/config
sed -i -- "s/127.0.0.1/$SERVER_IP/g" ~/.kube/config
scp ~/.kube/config tms@192.168.0.113:.kube/config #Copy config in main pc
