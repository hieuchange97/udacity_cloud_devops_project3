#!/bin/bash
REPO_NAME="udacity-hieuvm5"
SERVICE_NAME="udacity-postgres"

# Add new Helm repository
helm repo add $REPO_NAME https://charts.bitnami.com/bitnami
echo "Added repo name: $REPO_NAME"

# Install PostgreSQL
helm install --set primary.persistence.enabled=false $SERVICE_NAME $REPO_NAME/postgresql
echo "Installed postgre with name: $SERVICE_NAME"
