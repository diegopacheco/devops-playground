# Dolt

Git for Data
https://github.com/dolthub/dolt

## Experience Notes

## Commands

## Result

## What is Dolt?

```
Dolt is a SQL database with Git-style version control. You can fork, clone, branch, merge, push, and pull just like a Git repository, but the
targets are tables instead of files.

- Connects like any MySQL database for reading/modifying schema and data
- Version control exposed via system tables, functions, and stored procedures in SQL
- Git-like CLI for importing CSVs, committing changes, pushing to remotes, merging
- "Git versions files. Dolt versions tables. It's like Git and MySQL had a baby."

Ecosystem

- DoltHub — public hosting for Dolt databases (free for public data)
- DoltLab — self-hosted DoltHub
- Hosted Dolt — managed Dolt server
- Doltgres — Postgres-compatible version (Beta)

CLI Commands

Maps directly to Git: init, status, add, diff, reset, clean, commit, sql, sql-server, log, branch, checkout, merge, conflicts, cherry-pick,
revert, clone, fetch, pull, push, config, remote, backup, tag, blame, gc, filter-branch, merge-base, dump, and more.

Installation

- ~103MB single binary
- Linux/Mac: curl -L https://github.com/dolthub/dolt/releases/latest/download/install.sh | bash
- Arch Linux: pacman -S dolt
- Homebrew: brew install dolt
- MacPorts: sudo port install dolt
- Windows: MSI installer or choco install dolt
- Docker: dolthub/dolt (CLI) and dolthub/dolt-sql-server (server mode)
- From source: go install ./cmd/dolt (requires Go + cgo)

Key Features

- MySQL-compatible server via dolt sql-server (port 3306)
- Works with any MySQL client (recommended MySQL 8.4 LTS)
- Foreign keys, secondary indexes, triggers, check constraints, stored procedures
- Up to 12 table JOINs
- Branching: call dolt_checkout('-b', 'branch_name') — isolated schema/data changes
- Diffs: dolt_diff() table function, dolt_status, dolt_diff_<tablename> system tables
- Commits: call dolt_commit('-am', 'message') — version control write ops as stored procedures
- Merge: call dolt_merge('branch_name') — three-way merge with conflict detection
- Reset/Undo: dolt_reset('--hard'), dolt_revert(), dolt_undrop() — recover from mistakes including accidental DROP DATABASE
- Time travel: SELECT * FROM table AS OF 'branch_or_commit'
- Cell-level lineage: dolt_history_<tablename> shows row state at every commit; dolt_diff_<tablename> shows exactly when each cell changed
- Binlog replication: can be set up as a replica of an existing MySQL database — every write becomes a Dolt commit

SQL Version Control Pattern

- dolt_add() → stage tables
- dolt_commit() → commit changes
- dolt_checkout() → switch/create branches
- dolt_merge() → merge branches
- dolt_reset() → undo changes
- dolt_log → commit history
- dolt_diff → change tracking
- dolt_branches → list branches
- active_branch() → current branch
```  