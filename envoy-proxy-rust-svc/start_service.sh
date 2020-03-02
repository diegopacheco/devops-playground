#!/bin/sh
/main &
envoy -c /etc/service-envoy.yaml --service-cluster service