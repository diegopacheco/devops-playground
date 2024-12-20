### Run

```bash
./run-presto.sh
```

### Python

```bash
pip install presto-python-client
```
```bash
/bin/python3 presto-py.py
```
```
❯ /bin/python3 presto-py.py
[['74053f8d3d77', 'http://172.17.0.2:8080', '0.290-6a04267', True, 'active']]
```

### Cli

```bash
./run-cli.sh
```
```
❯ ./run-cli.sh
presto> SELECT * FROM system.runtime.nodes;
   node_id    |        http_uri        | node_version  | coordinator | state  
--------------+------------------------+---------------+-------------+--------
 74053f8d3d77 | http://172.17.0.2:8080 | 0.290-6a04267 | true        | active 
(1 row)

Query 20241220_093929_00009_jrrg3, FINISHED, 1 node
Splits: 17 total, 17 done (100.00%)
[Latency: client-side: 122ms, server-side: 95ms] [1 rows, 54B] [10 rows/s, 568B/s]

presto> 
```