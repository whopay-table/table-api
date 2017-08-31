#!/bin/bash
mv docker-compose.override.yml docker-compose.bak.yml
cp docker-compose.production.yml docker-compose.override.yml
