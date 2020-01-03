#! /bin/bash

# Set environment variables
source env_variables
. kube_functions

# Delete existing services for namespace
./delete-layers.sh ${namespace} 

$(aws ecr get-login --no-include-email --region eu-west-2)
docker tag graphile/postgraphile:latest 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-graphql:latest
docker push 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-graphql:latest

# Build Docker Images
$(aws ecr get-login --no-include-email --region eu-west-2)
echo "Building ${UI_image} from ${UI_repo}"
docker build -t ${UI_image}:${namespace} ${UI_repo}
docker tag takeon-dev-ui:${namespace} 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-ui:${namespace}
docker push 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-ui:${namespace}

echo "Building ${BL_image} from ${BL_repo}"
docker build -t ${BL_image}:${namespace} ${BL_repo}
docker tag takeon-dev-bl:${namespace} 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-bl:${namespace}
docker push 014669633018.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-bl:${namespace}

# Create namespace and deploy all services
# Keeping delete as manual step so that this doesn't overwrite existing namespace
./deploy-services.sh ${namespace}
