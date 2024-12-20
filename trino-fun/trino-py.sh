from trino.dbapi import connect

conn = connect(
    host="localhost",
    port=8080,
    user="<username>",
    catalog="<catalog>",
    schema="<schema>",
)
cur = conn.cursor()
result = cur.execute("SELECT * FROM system.runtime.nodes")
rows = cur.fetchall()
print(rows)

r2 = cur.execute("SELECT count(*) FROM tpch.sf1.nation")
print(r2.fetchall())