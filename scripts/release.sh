
VERSION=$1

if [[ ! $VERSION =~ v[0-9\.]+ ]]
then
    echo "Error: Version must be in v[0-9\.]+ form"
    exit 1
fi

PLAIN_VERSION=$(echo $VERSION | sed -e 's/v//g')

# Reset local changes, fetch all tas, and checkout required version.
git reset --hard
git fetch --all --tags --prune
git checkout $1

eval "sed -e 's/{{VERSION}}/$PLAIN_VERSION/g' ./scripts/docker-compose.production.yml" > ./docker-compose.production.yml

# Stop production server.
systemctl stop table-api

# Pull docker image.
docker compose pull app

# Migrate the database.
docker-compose -f docker-compose.yml -f docker-compose.production.yml run app rake db:migrate

# Run production server.
systemctl start table-api
