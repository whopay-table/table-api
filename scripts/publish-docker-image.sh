#!/bin/bash
echo "Building table-api:$1"


if [ $2 = "--use-cache" ]; then
    docker build -f Dockerfile.prod -t "table-api:$1" .
else
    docker build --no-cache -f Dockerfile.prod -t "table-api:$1" .
fi

docker tag "table-api:$1" "jmbyun/table-api:$1"
docker push "jmbyun/table-api:$1"
