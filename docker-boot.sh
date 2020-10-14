#!/bin/bash

docker-compose run --rm --no-deps web rails new . --force --no-deps --database=postgresql
docker-compose build