#!/usr/bin/env bash
set -euo pipefail
source "$(cd "$(dirname "$0")" && pwd)/lib.sh"

log "toolchain $(rustc --version), $(cargo --version)"

log "building and testing the rust app"
(cd "$ROOT/app" && cargo build --locked && cargo test --locked)

log "building the app image"
dc build

log "pulling the iggy server and web ui images"
podman pull -q docker.io/apache/iggy:0.8.0
podman pull -q docker.io/apache/iggy-web-ui:0.3.0

log "build done"
