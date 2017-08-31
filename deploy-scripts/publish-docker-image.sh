docker build -f Dockerfile.prod -t "table-api:$1" .
docker tag "table-api:$1" "jmbyun/table-api:$1"
docker push "jmbyun/table-api:$1"
