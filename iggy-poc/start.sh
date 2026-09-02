#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

log "starting the iggy server and the web ui"
dc up -d iggy ui >/dev/null
wait_iggy
wait_ui

log "starting the consumer group $CONSUMER_GROUP"
dc up -d consumer >/dev/null

log "running the producer for $IGGY_MESSAGE_COUNT messages"
dc up -d producer >/dev/null
wait_container_exit iggy-producer
podman logs iggy-producer

wait_container_exit iggy-consumer
podman logs iggy-consumer

log "the server and the web ui stay up, run ./stop.sh when done"
print_access
