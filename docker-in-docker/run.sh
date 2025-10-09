#!/bin/bash

podman run -d --name dind-poc --privileged docker:dind
sleep 1
podman exec dind-poc docker info
