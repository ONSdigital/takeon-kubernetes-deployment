#! /bin/bash

source env_variables
. kube_functions


# Build Docker Images
echo "Building ${UI_image} from ${UI_repo}"
docker build -t ${UI_image}:${namespace} ${UI_repo}
docker tag takeon-dev-ui:${namespace} 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-ui:${namespace}
docker push 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-ui:${namespace}

# Delete previous pod
kubectl delete pods -l app=takeon-ui -n ${namespace} 