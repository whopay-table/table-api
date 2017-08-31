#!/bin/bash
echo "Building table-api:$1"
docker build --no-cache -f Dockerfile.prod -t "table-api:$1" .
docker tag "table-api:$1" "jmbyun/table-api:$1"
docker push "jmbyun/table-api:$1"
