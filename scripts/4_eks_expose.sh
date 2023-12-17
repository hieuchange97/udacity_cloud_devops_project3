BE_DEPLOYMENT_NAME="backend-coworking"
kubectl expose deployment $BE_DEPLOYMENT_NAME --type=LoadBalancer --name=publicbackend
