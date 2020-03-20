#! /bin/bash

# Set environment variables
source env_variables
. kube_functions

# Delete existing services for namespace
./delete-layers.sh ${namespace} 

# Deploy local graphql container
docker pull graphile/postgraphile
$(aws ecr get-login --no-include-email --region eu-west-2)
docker tag graphile/postgraphile:latest 226575302242.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-sandbox-graphql:latest
docker push 226575302242.dkr.ecr.eu-west-2.amazonaws.com/takeon-dev-sandbox-graphql:latest

$(aws ecr get-login --no-include-email --region eu-west-2)
echo "Building ${UI_image} from ${UI_repo}"
docker build -t ${UI_image} ${UI_repo}
docker tag ${UI_image}:${namespace} ${account_id}.dkr.ecr.eu-west-2.amazonaws.com/${UI_image}:${namespace}
docker push ${account_id}.dkr.ecr.eu-west-2.amazonaws.com/${UI_image}:${namespace}
echo "Building ${BL_image} from ${BL_repo}"
docker build -t ${BL_image} ${BL_repo}
docker tag ${BL_image}:${namespace} ${account_id}.dkr.ecr.eu-west-2.amazonaws.com/${BL_image}:${namespace}
docker push ${account_id}.dkr.ecr.eu-west-2.amazonaws.com/${BL_image}:${namespace}
# ./ui.sh

# ./business.sh

# Create namespace and deploy all services
# Keeping delete as manual step so that this doesn't overwrite existing namespace
./deploy-services.sh ${namespace}
