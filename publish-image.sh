docker build -f Dockerfile.prod -t "table-api:0.1"
docker tag "table-api:0.1" "jmbyun/table-api:0.1"
docker push "jmbyun/table-api:0.1"
