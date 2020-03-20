#! /bin/bash

source env_variables
. kube_functions

#$(aws ecr get-login --no-include-email --region eu-west-2)
aws ecr get-login-password --region eu-west-2 | docker login --username AWS --password-stdin 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${BL_image}
echo "Building ${BL_image} from ${BL_repo}"
docker build -t ${BL_image}:${namespace} ${BL_repo}
docker tag ${BL_image}:${namespace} 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${BL_image}:${namespace}
docker push 226575302242.dkr.ecr.eu-west-2.amazonaws.com/${BL_image}:${namespace}

# Delete previous pod
kubectl delete pods -l app=business-layer -n ${namespace} 
