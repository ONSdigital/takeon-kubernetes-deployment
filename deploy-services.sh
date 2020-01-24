# Script to deploy all containers and services to kubernetes
# Params: Namespace to deploy to

namespace=$1

source env_variables
. kube_functions

# Check for no parameters or blank paremeter
if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "No arguments supplied - Please provide a valid namespace"
    exit 1
fi

#aws eks --region eu-west-2 update-kubeconfig --name takeon-dev-eks-cluster
kubectl create namespace $namespace
# Check status of previous create namespace command
error_code=`echo $?`
echo $error_code

if [ $error_code -ne 0 ];
then
  echo "Namespace already exists"
  exit 1
else
  echo "Namespace created"
fi

# Create connection string secret 
kubectl apply -f secret-connection-string.yaml
kubectl get secret gql-connection-string  -o yaml -n takeon-dev-test > gql-secret.yaml
gql_connection_string=$(python3 parse-secret.py) 
echo $gql_connection_string

# Run create secrets script for Persistence Layer
#./create-secrets.sh $namespace

containers=(service-account.yaml secret.yaml takeon-graphql-deployment.yaml takeon-business-layer-deployment.yaml takeon-ui-deployment.yaml)

for container in ${containers[@]};
do
    apply $container
    echo "Deployed $container to $namespace"
done
