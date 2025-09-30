# Grafana Dashbaord Tests

## Results 

```bash
❯ ./test.sh
Waiting for Grafana to be ready...
Testing grafanactl config check...
✔ Configuration file: /root/.config/grafanactl/config.yaml
✔ Current context: default

Context: default
================
✔ Configuration: valid
✔ Connectivity: online
✔ Grafana version: 12.2.0


Fetching all dashboards...
fetch https://dl-cdn.alpinelinux.org/alpine/v3.22/main/aarch64/APKINDEX.tar.gz
fetch https://dl-cdn.alpinelinux.org/alpine/v3.22/community/aarch64/APKINDEX.tar.gz
(1/11) Installing brotli-libs (1.1.0-r2)
(2/11) Installing c-ares (1.34.5-r0)
(3/11) Installing libunistring (1.3-r0)
(4/11) Installing libidn2 (2.3.7-r0)
(5/11) Installing nghttp2-libs (1.65.0-r0)
(6/11) Installing libpsl (0.21.5-r3)
(7/11) Installing zstd-libs (1.5.7-r0)
(8/11) Installing libcurl (8.14.1-r1)
(9/11) Installing curl (8.14.1-r1)
(10/11) Installing oniguruma (6.9.10-r0)
(11/11) Installing jq (1.8.0-r0)
Executing busybox-1.37.0-r18.trigger
OK: 14 MiB in 28 packages
Dashboard validation results:
[]

Total dashboards found: 0
Dashboard validation: FAILED (no dashboards found)
```