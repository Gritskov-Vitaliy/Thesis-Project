#!/bin/bash

port=$(kubectl get svc app --namespace=app --output=jsonpath='{range .spec.ports[0]}{.port}')
ip=$(kubectl get svc app --namespace=app | awk '{if ($1 == "app") { print $4 }}')
while [[ $ip == "<pending>" ]]
    do
        sleep 3
        ip=$(kubectl get svc app --namespace=app | awk '{if ($1 == "app") { print $4 }}')
    done

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

echo "http://$ip:$port"
echo "$version"

exit 0
