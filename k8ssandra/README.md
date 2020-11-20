### Install
```bash
./install.sh

# now for each script run in a different console
./export-grafana.sh
./export-prometheus.sh
./export-reaper.sh
./export-cass-port.sh
```

### Connect to CQLSH
```bash
export CQLSH_PORT=9049; bin/cqlsh
```