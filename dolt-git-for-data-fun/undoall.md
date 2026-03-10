# Undo All Dolt Operations

```bash
cd mydb
dolt reset --hard
dolt checkout main
dolt branch -d -f feature-branch
dolt sql -q "drop table if exists employees;"
dolt add .
dolt commit -m "Cleaned up everything"
```

```bash
cd ..
rm -rf mydb
```
