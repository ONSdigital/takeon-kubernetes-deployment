#! /bin/bash

source env_variables
. kube_functions

#$(aws ecr get-login --no-include-email --region eu-west-2)
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${UI_image}
# Build Docker Images
echo "Building ${UI_image} from ${UI_repo}"
docker build -t ${UI_image}:${namespace} ${UI_repo}
docker tag ${UI_image}:${namespace} 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${UI_image}:${namespace}
docker push 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${UI_image}:${namespace}

# Delete previous pod
kubectl delete pods -l app=takeon-ui -n ${namespace}