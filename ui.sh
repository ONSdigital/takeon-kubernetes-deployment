#! /bin/bash

source env_variables
. kube_functions

$(aws ecr get-login --no-include-email --region eu-west-2)
# Build Docker Images
echo "Building ${UI_image} from ${UI_repo}"
docker build -t ${UI_image}:${namespace} ${UI_repo}
docker tag takeon-dev-sandbox-ui:${namespace} 226575302242.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-sandbox-ui:${namespace}
docker push 226575302242.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-sandbox-ui:${namespace}

# Delete previous pod
kubectl delete pods -l app=takeon-ui -n ${namespace} 