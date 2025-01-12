#!/bin/bash

docker build -t blog:test --no-cache --network=host ../

docker run --rm --net=host blog:test
