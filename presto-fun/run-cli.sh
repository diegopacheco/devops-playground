#!/bin/bash

docker run -ti --network host --entrypoint presto-cli prestodb/presto --server localhost:8080