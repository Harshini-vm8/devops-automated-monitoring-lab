#!/bin/bash

# Create a Kind cluster
kind create cluster --name devops-lab

# Load Docker images into the cluster (if needed, e.g., for local builds)
# kind load docker-image my-python-app:latest --name devops-lab

# Apply Kubernetes manifests
kubectl apply -f k8s-deployment.yml
kubectl apply -f k8s-service.yml

# Apply Prometheus and Grafana manifests
kubectl apply -f prometheus-rbac.yml
kubectl apply -f prometheus-config.yml
kubectl apply -f prometheus-deployment.yml
kubectl apply -f prometheus-service.yml

echo "Kubernetes cluster 'devops-lab' is ready."
