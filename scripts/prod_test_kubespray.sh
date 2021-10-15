#!/bin/bash

port=$(kubectl get svc app --output=jsonpath='{range .spec.ports[0]}{.nodePort}')
ip=$(gcloud compute instances list | awk '{if ($1 == "thesis-project-worker-0") { print $5 }}')

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
