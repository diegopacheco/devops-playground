### Run

```bash
./run-trino.sh
```

### Queries

```bash
./run-queries.sh
```

```
❯ ./run-queries.sh
trino> select count(*) from tpch.sf1.nation;
 _col0 
-------
    25 
(1 row)

Query 20241220_091957_00000_8g2zf, FINISHED, 1 node
Splits: 13 total, 13 done (100.00%)
2.85 [25 rows, 0B] [8 rows/s, 0B/s]

trino> 
```

### Python

```bash
pip install trino
```

```bash
/bin/python3 trino-py.sh
```
```
❯ /bin/python3 trino-py.sh
[['37ca7173b7dd', 'http://172.17.0.2:8080', '468', True, 'active']]
[[25]]
```