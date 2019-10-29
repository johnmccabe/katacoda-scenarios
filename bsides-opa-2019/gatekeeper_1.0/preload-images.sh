#! /bin/bash

# Preload docker images used in the workshop (run this first so Katacoda has time to provision Kube)
docker pull openpolicyagent/opa:0.12.1
docker pull openpolicyagent/kube-mgmt:0.8
docker pull docker.io/kubernetes/pause
docker pull gcr.io/google_containers/pause-amd64:3.0

# Wait for Kubernetes to be up
echo -n "Waiting for Kubernetes to be ready to use" &&
until kubectl get pod 2>/dev/null ; do echo -n . ; sleep 1 ; done ; echo &&
echo "Ready to go!"
