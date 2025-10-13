#!/bin/bash
set -e

BASE_URL="http://localhost:30080"

echo "Casting votes..."

echo "Voting for warriors (5 votes)..."
for i in {1..5}; do
  curl -s "${BASE_URL}/vote?team=1"
  echo ""
done

echo "Voting for lakers (2 votes)..."
for i in {1..2}; do
  curl -s "${BASE_URL}/vote?team=2"
  echo ""
done

echo "Voting for bucks (3 votes)..."
for i in {1..3}; do
  curl -s "${BASE_URL}/vote?team=3"
  echo ""
done

echo "Voting for okc (1 vote)..."
curl -s "${BASE_URL}/vote?team=4"
echo ""

echo ""
echo "Checking vote counts..."
curl -s "${BASE_URL}/check" | jq '.'

echo ""
echo "Determining winner..."
RESULTS=$(curl -s "${BASE_URL}/check")
WARRIORS=$(echo $RESULTS | jq -r '.warriors')
LAKERS=$(echo $RESULTS | jq -r '.lakers')
BUCKS=$(echo $RESULTS | jq -r '.bucks')
OKC=$(echo $RESULTS | jq -r '.okc')

MAX=$WARRIORS
WINNER="warriors"

if [ "$LAKERS" -gt "$MAX" ]; then
  MAX=$LAKERS
  WINNER="lakers"
fi

if [ "$BUCKS" -gt "$MAX" ]; then
  MAX=$BUCKS
  WINNER="bucks"
fi

if [ "$OKC" -gt "$MAX" ]; then
  MAX=$OKC
  WINNER="okc"
fi

echo "Winner: $WINNER with $MAX votes!"
