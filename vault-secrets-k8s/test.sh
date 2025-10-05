#!/bin/bash

echo "Testing application endpoint..."
echo ""

response=$(curl -s http://localhost:8080/secret)

echo "Secret retrieved from Vault:"
echo "$response" | jq .

echo ""
echo "Individual fields:"
echo "Username: $(echo $response | jq -r .username)"
echo "Password: $(echo $response | jq -r .password)"
echo "API Key: $(echo $response | jq -r .api_key)"
