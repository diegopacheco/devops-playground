# Dolt

Git for Data
https://github.com/dolthub/dolt

Dolt is a SQL database with Git-style version control. You can fork, clone, branch, merge, push, and pull just like a Git repository, but the targets are tables instead of files.

## Experience Notes

* Dolt CLI maps directly to Git commands but targets tables instead of files
* Works with any MySQL client
* Branching, merging, diffing, and history tracking all work through SQL
* `dolt_history_<table>` shows row state at every commit - cell-level lineage
* `dolt_diff` shows exactly what changed between commits or branches
* Fast-forward merges work the same as Git
* Single binary ~103MB, easy to install via brew

## Commands

```bash
./run-sql.sh
```

## Result

```
+----+------------+-----------+-----------------+
| id | first_name | last_name | role            |
+----+------------+-----------+-----------------+
| 1  | Diego      | Pacheco   | Senior Engineer |
| 2  | John       | Doe       | Manager         |
| 3  | Jane       | Smith     | Designer        |
| 4  | Bob        | Jones     | DevOps          |
+----+------------+-----------+-----------------+

=== History for Diego (id=1) ===
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+
| id | first_name | last_name | role            | commit_hash                      | committer     | commit_date                |
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+
| 1  | Diego      | Pacheco   | Engineer        | 4akej5krob330mhdljr57jkq29i09b1v | Diego Pacheco | 2026-03-10 07:51:44.229000 |
| 1  | Diego      | Pacheco   | Senior Engineer | n1fjbanc3q77qto35h1j2est264f8bmm | Diego Pacheco | 2026-03-10 07:51:44.839000 |
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+
```

### Run SQL Result

```
❯ ./run-sql.sh
Successfully initialized dolt data repository.
Config successfully updated.
Config successfully updated.
commit jfevbdgf8eih27ctft2m5lmkasuu2vcq (HEAD -> main)
Author: Diego Pacheco <diegopacheco@gmail.com>
Date:  Tue Mar 10 00:54:45 -0700 2026

    Initial schema and data


=== All Employees ===
+----+------------+-----------+----------+
| id | first_name | last_name | role     |
+----+------------+-----------+----------+
| 1  | Diego      | Pacheco   | Engineer |
| 2  | John       | Doe       | Manager  |
| 3  | Jane       | Smith     | Designer |
+----+------------+-----------+----------+


=== Creating branch and making changes ===
Switched to branch 'feature-branch'
commit kpdeucnu5nohb06pcjg290lv2nmn2kb1 (HEAD -> feature-branch)
Author: Diego Pacheco <diegopacheco@gmail.com>
Date:  Tue Mar 10 00:54:45 -0700 2026

    Added Bob and promoted Diego


=== Diff between main and feature-branch ===
diff --dolt a/employees b/employees
--- a/employees
+++ b/employees
+---+----+------------+-----------+-----------------+
|   | id | first_name | last_name | role            |
+---+----+------------+-----------+-----------------+
| < | 1  | Diego      | Pacheco   | Engineer        |
| > | 1  | Diego      | Pacheco   | Senior Engineer |
| + | 4  | Bob        | Jones     | DevOps          |
+---+----+------------+-----------+-----------------+

=== Merging feature-branch into main ===
Switched to branch 'main'
Fast-forward
Updating kpdeucnu5nohb06pcjg290lv2nmn2kb1..kpdeucnu5nohb06pcjg290lv2nmn2kb1
employees | 2 +*
1 tables changed, 1 rows added(+), 1 rows modified(*), 0 rows deleted(-)
no changes added to commit (use "dolt add")

=== Final Employees ===
+----+------------+-----------+-----------------+
| id | first_name | last_name | role            |
+----+------------+-----------+-----------------+
| 1  | Diego      | Pacheco   | Senior Engineer |
| 2  | John       | Doe       | Manager         |
| 3  | Jane       | Smith     | Designer        |
| 4  | Bob        | Jones     | DevOps          |
+----+------------+-----------+-----------------+


=== Commit Log ===
commit kpdeucnu5nohb06pcjg290lv2nmn2kb1 (HEAD -> feature-branch, main)
Author: Diego Pacheco <diegopacheco@gmail.com>
Date:  Tue Mar 10 00:54:45 -0700 2026

    Added Bob and promoted Diego

commit jfevbdgf8eih27ctft2m5lmkasuu2vcq
Author: Diego Pacheco <diegopacheco@gmail.com>
Date:  Tue Mar 10 00:54:45 -0700 2026

    Initial schema and data

commit u20v3mqratqum7hgkrbs430btqs1celr
Author: diegopacheco <diego.pacheco.it@gmail.com>
Date:  Tue Mar 10 00:54:44 -0700 2026

    Initialize data repository


=== History for Diego (id=1) ===
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+
| id | first_name | last_name | role            | commit_hash                      | committer     | commit_date                |
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+
| 1  | Diego      | Pacheco   | Engineer        | jfevbdgf8eih27ctft2m5lmkasuu2vcq | Diego Pacheco | 2026-03-10 07:54:44.570000 |
| 1  | Diego      | Pacheco   | Senior Engineer | kpdeucnu5nohb06pcjg290lv2nmn2kb1 | Diego Pacheco | 2026-03-10 07:54:45.191000 |
+----+------------+-----------+-----------------+----------------------------------+---------------+----------------------------+


=== Done ===
```