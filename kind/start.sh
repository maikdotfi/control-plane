#!/bin/bash
echo "Cleaning up any existing clusters or registry..."
kind delete cluster --name=dev
docker rm --force "kind-registry"

echo "Creating cluster..."
kind create cluster --kubeconfig kind.kubeconfig --config config.yml
echo "Done!"
echo "Creating registry..."
docker run -d --restart=always -p "127.0.0.1:5000:5000" --name "kind-registry" registry:2
docker network connect "kind" "kind-registry" || true
docker ps
echo "Configuring configMap..."
kubectl apply -f registry-cm.yaml 
echo "Done!"
echo "Testing registry"
docker pull nginx:latest
docker tag nginx:latest localhost:5000/nginx:latest
docker push localhost:5000/nginx:latest
printf "All done! Now set the kubeconfig:\n"
echo "export KUBECONFIG=$PWD/kind.kubeconfig"
