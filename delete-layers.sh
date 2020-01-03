namespace=$1

# Check for no parameters or blank paremeter
if [ $# -eq 0 ] || [ -z "$1" ]
  then
    echo "No arguments supplied - Please provide a valid namespace"
    exit 1
fi

kubectl delete deployment,service business-layer -n $namespace
kubectl delete deployment,service takeon-ui -n $namespace
kubectl delete deployment,service graphql -n $namespace
