#!/bin/bash

# Define the IP range
start_ip=2
end_ip=10
base_ip="172.17.0."

# Loop through the IP range
for i in $(seq $start_ip $end_ip); do
  ip="${base_ip}${i}"
  ping -c 1 -W 1 $ip > /dev/null 2>&1
  if [ $? -eq 0 ]; then
    echo "IP $ip is in use."
  else
    echo "IP $ip is free."
  fi
done