#!/bin/bash

#
# Need to produce valid JSON to be parsed by terraform
#
d="$(date)"
echo "{\"result\": \"$d\"}"