#! /bin/bash

# Preload docker images used in the workshop (run this first so Katacoda has time to provision Kube)
declare -a StringArray=("confluentinc/cp-zookeeper:4.0.0-3" "openpolicyagent/opa:latest")
echo "Cache Images"
for image in ${StringArray[@]}; do
    echo -n " - ${image}"
    docker pull ${image} 1>/dev/null
    echo " [DONE]"
done

mkdir -p policies
cp kafka.rego policies/

# Wait for Kubernetes to be up
# echo -n "Waiting for Docker to be ready to use" &&
# until kubectl get pod 2>/dev/null ; do echo -n . ; sleep 1 ; done ; echo &&
# echo "Ready to go!"
