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
