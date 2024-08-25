#!/bin/bash

ab -k -c 1000 -n 15000 http://localhost:8080/actuator/health