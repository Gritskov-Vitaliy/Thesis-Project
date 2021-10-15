#!/bin/bash

port=$(kubectl get svc --namespace=app | awk '{if ($1 == "app") { print $5 }}' | head -1 | cut -d: -f2 | cut -d/ -f1)
ip=$(minikube ip)

check_web () {
    curl http://$ip:$port | grep Gritskov
}

until check_web
    do
    sleep 3
    done

hash=$(git describe --always)
version=$(curl http://$ip:$port | grep Version | cut -d '<' -f 1)

until [[ $version == "    Version $hash" ]]
    do
    sleep 3
    version=$(curl http://$ip:$port | grep Version | cut -d '<' -f 1)
    done

exit 0
