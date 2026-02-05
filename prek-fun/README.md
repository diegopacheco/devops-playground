# Prek 

Pre commit hook in Rust.
https://github.com/j178/prek

## Install

```
cargo binstall prek
```

## Usage

```
prek run
```

```
.pre-commit-config.yaml
```
```
repos:
  - repo: https://github.com/pre-commit/pre-commit-hooks
    rev: v6.0.0
    hooks:
      - id: check-yaml
      - id: end-of-file-fixer
```

hook with git automatically:

```
prek install
```