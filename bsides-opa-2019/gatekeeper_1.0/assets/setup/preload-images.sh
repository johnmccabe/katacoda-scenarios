#! /bin/bash

# Preload docker images used in the workshop (run this first so Katacoda has time to provision Kube)
declare -a StringArray=("openpolicyagent/opa:0.14.2-rootless" "openpolicyagent/kube-mgmt:0.9" "docker.io/kubernetes/pause" "gcr.io/google_containers/pause-amd64:3.0")
echo "Cache Images"
for image in ${StringArray[@]}; do
    docker pull ${image} 1>/dev/null
    echo "- ${image}"
done

# Wait for Kubernetes to be up
echo -n "Waiting for Kubernetes to be ready to use" &&
until kubectl get pod 2>/dev/null ; do echo -n . ; sleep 1 ; done ; echo &&
echo "Ready to go!"
