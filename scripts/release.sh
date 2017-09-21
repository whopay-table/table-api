
VERSION=$1

if [[ ! $VERSION =~ v[0-9\.]+ ]]
then
    echo "Error: Version must be in v[0-9\.]+ form"
    exit 1
fi

PLAIN_VERSION=$(echo $VERSION | sed -e 's/v//g')

echo "Reset local changes, checkout $VERSION from remote."

git reset --hard
git fetch --all --tags --prune
git checkout $1

echo "Replacing docker-compose for production."

eval "sed -e 's/{{VERSION}}/$PLAIN_VERSION/g' ./scripts/docker-compose.production.yml" > ./docker-compose.production.yml

echo "Stopping production API server."

systemctl stop table-api

echo "Pulling docker image $VERSION."

docker compose pull app

echo "Migrating the database."

docker-compose -f docker-compose.yml -f docker-compose.production.yml run app rake db:migrate

echo "Starting production API server."

systemctl start table-api

echo "Done."
