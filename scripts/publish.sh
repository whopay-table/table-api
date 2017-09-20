#!/bin/bash

if [ x$(git rev-parse --abbrev-ref HEAD) != xmaster ]
then
    echo "Error: Cannot publish non-master branch."
    exit 1
fi

if [ x$(git diff --exit-code) != x ]
then
    echo "Error: There are local unstaged changes in your code."
    exit 1
fi

if [ x$(git diff --cached --exit-code) != x ]
then
    echo "Error: There are local uncommited changes in your code."
    exit 1
fi

if [ x$()]

if [ x$(git rev-parse master) != x$(git rev-parse origin/master) ]
then
    echo "Error: Local master branch is not synced with the remote master branch."
    exit 1
fi

if [[ "$1" =~ "v[0-9\.]+" ]]
then
    echo "Publishing version $1"
else
    echo "Error: Version must be in v[0-9\.]+ form"
fi

git tag
