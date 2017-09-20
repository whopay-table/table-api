#!/bin/bash


if [ x$(git rev-parse --abbrev-ref HEAD | git rev-parse $(cat -)) = x$(git rev-parse --abbrev-ref HEAD | git rev-parse origin/$(cat -)) ]
then
    echo same
fi
