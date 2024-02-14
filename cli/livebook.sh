#!/usr/bin/env bash

docker run \
    --rm \
    -p 8080:8080 \
    -p 8081:8081 \
    --pull always \
    -u $(id -u):$(id -g) \
    -v $(pwd):/data \
    -e LIVEBOOK_PASSWORD=elixirisbest \
    ghcr.io/livebook-dev/livebook:latest-cuda11.8
