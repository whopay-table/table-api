#!/bin/bash

VERSION=$1

if [ x$(git rev-parse --abbrev-ref HEAD) != xmaster ]
then
    echo "Error: Cannot publish non-master branch."
    exit 1
fi

if [ "x$(git diff --exit-code)" != "x" ]
then
    echo "Error: There are local unstaged changes in your code."
    exit 1
fi

if [ "x$(git diff --cached --exit-code)" != "x" ]
then
    echo "Error: There are local uncommited changes in your code."
    exit 1
fi

if [ "x$(git rev-parse master)" != "x$(git rev-parse origin/master)" ]
then
    echo "Error: Local master branch is not synced with the remote master branch."
    exit 1
fi

if [[ $VERSION =~ v[0-9\.]+ ]]
then
    echo "Tagging $VERSION on repository."
else
    echo "Error: Version must be in v[0-9\.]+ form"
fi

PLAIN_VERSION=$(echo $VERSION | sed -e 's/v//g')

git tag $VERSION master
git push origin $VERSION

echo "Building docker image for $VERSION."

if [ "$2" = "--use-cache" ]
then
    echo "Using cache for docker image building."
    docker build -f Dockerfile.prod -t "table-api:$PLAIN_VERSION" .
else
    echo "Ignoring cache for docker image building."
    docker build --no-cache -f Dockerfile.prod -t "table-api:$PLAIN_VERSION" .
fi

echo "Pushing docker image for $VERSION."

docker tag table-api:$PLAIN_VERSION jmbyun/table-api:$PLAIN_VERSION
docker push jmbyun/table-api:$PLAIN_VERSION
