# Script to deploy all containers and services to kubernetes
# Params: Namespace to deploy to

namespace=$1

# Check for no parameters or blank paremeter
if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "No arguments supplied - Please provide a valid namespace"
    exit 1
fi

aws eks --region eu-west-2 update-kubeconfig --name takeon-dev-eks-cluster
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

# Run create secrets script for Persistence Layer
./create-secrets.sh $namespace

containers=(service-account.yaml takeon-business-layer-deployment.yaml takeon-persistence-layer-deployment.yaml takeon-ui-deployment.yaml takeon-graphql-deployment.yaml)

for container in ${containers[@]};
do
    kubectl apply -f $container -n $namespace
    echo "Deployed $container to $namespace"
done
