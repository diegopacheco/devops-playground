#!/bin/bash

curl -s http://localhost:8080/slow/1000 | jq .