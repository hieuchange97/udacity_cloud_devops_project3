set -e

LOCAL_PORT=5432
REMOTE_PORT=5432
TYPE_NAME=udacity-postgres-postgresql

POSTGRES_PASSWORD=$(kubectl get secret --namespace default udacity-postgres-postgresql -o jsonpath="{.data.postgres-password}" | base64 -d)
kubectl port-forward --namespace default svc/$TYPE_NAME $LOCAL_PORT:$REMOTE_PORT > /dev/null 2>&1 &

pid=$!
echo current pid: $pid

# Manage the life circle of script, execute killing process when finish
trap '{
    # if variable $pid is empty, do nothing
    if ps -p $pid > /dev/null; then
        echo "pid is set"
        echo "killing $pid"
        kill $pid
    else
        echo "pid is unset"
    fi
}' EXIT

# Check and wait for the current local port is free or not, if not then waitting for the port free and execute seeding data
while ! nc -vz localhost $LOCAL_PORT > /dev/null 2>&1 ; do
    echo "$LOCAL_PORT is using in another process. Wait for it finish"
    sleep 1
done

PGPASSWORD=$POSTGRES_PASSWORD psql --host 127.0.0.1 -U postgres -d postgres -p $LOCAL_PORT < ./db/1_create_tables.sql &&\
PGPASSWORD=$POSTGRES_PASSWORD psql --host 127.0.0.1 -U postgres -d postgres -p $LOCAL_PORT < ./db/2_seed_users.sql &&\
PGPASSWORD=$POSTGRES_PASSWORD psql --host 127.0.0.1 -U postgres -d postgres -p $LOCAL_PORT < ./db/3_seed_tokens.sql

