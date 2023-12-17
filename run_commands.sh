# Using heml and set up Bitnami Repository
helm repo add udacity-pr3 https://charts.bitnami.com/bitnami

# Install PostgreSQL Helm Chart
helm install udacity-postgre udacity-project3/postgresql

# The password can be retrieved with the following command:
export POSTGRES_PASSWORD=$(kubectl get secret --namespace default udacity-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
echo $POSTGRES_PASSWORD

# To connect to your database run the following command:
kubectl run udacity-postgresql-client --rm --tty -i --restart='Never' --namespace default --image docker.io/bitnami/postgresql:16.1.0-debian-11-r0 --env="PGPASSWORD=EsaZY6hJJo" --command -- psql --host udacity-postgresql -U postgres -d postgres -p 5432

# Connecting Via Port Forwarding
kubectl port-forward --namespace default svc/udacity-postgresql 5432:5432 & PGPASSWORD=EsaZY6hJJo psql --host 127.0.0.1 -U postgres -d postgres -p 5432

# Connecting Via a Pod
kubectl exec -it udacity-postgresql-0 bash 
PGPASSWORD="EsaZY6hJJo" psql postgres://postgres@udacity-postgresql:5432/postgres -c \l

kubectl port-forward svc/udacity-postgresql 5432:5432
kubectl port-forward --namespace default svc/udacity-postgresql 5432:5432 & PGPASSWORD=EsaZY6hJJo psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < ./db/1_create_tables.sql
kubectl port-forward --namespace default svc/udacity-postgresql 5432:5432 & PGPASSWORD=EsaZY6hJJo psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < ./db/2_seed_users.sql
kubectl port-forward --namespace default svc/udacity-postgresql 5432:5432 & PGPASSWORD=EsaZY6hJJo psql --host 127.0.0.1 -U postgres -d postgres -p 5432 < ./db/3_seed_tokens.sql

# Try to connect to application
DB_USERNAME=postgres DB_PASSWORD=NL944Hzz98 python app.py

# Expose the Backend API to the Internet
kubectl expose deployment backend-coworking --type=LoadBalancer --name=publicbackend

kubectl exec --stdin --tty postgres-postgresql-0 -- /bin/bash

ClusterName=hieuvm5-cluster
RegionName=us-east-1
FluentBitHttpPort='2020'
FluentBitReadFromHead='Off'
[[ ${FluentBitReadFromHead} = 'On' ]] && FluentBitReadFromTail='Off'|| FluentBitReadFromTail='On'
[[ -z ${FluentBitHttpPort} ]] && FluentBitHttpServer='Off' || FluentBitHttpServer='On'
curl https://raw.githubusercontent.com/aws-samples/amazon-cloudwatch-container-insights/latest/k8s-deployment-manifest-templates/deployment-mode/daemonset/container-insights-monitoring/quickstart/cwagent-fluent-bit-quickstart.yaml | sed 's/{{cluster_name}}/'${ClusterName}'/;s/{{region_name}}/'${RegionName}'/;s/{{http_server_toggle}}/"'${FluentBitHttpServer}'"/;s/{{http_server_port}}/"'${FluentBitHttpPort}'"/;s/{{read_from_head}}/"'${FluentBitReadFromHead}'"/;s/{{read_from_tail}}/"'${FluentBitReadFromTail}'"/' | kubectl apply -f -