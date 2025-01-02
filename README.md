# [`postgres-parallel-copy-sh`](dist/postgres-parallell-copy.sh)

This repository contains shell scripts for parallel copying CSV/TSV data into a PostgreSQL table

## Usage

```sh
Usage: postgres-parallel-copy -f <file> -t <table> [-b <batch_size>] [-c <columns>] [-o <options>] [-p <max_parallel>]

Options:  
  -f    Input file containing rows to copy (required)
  -t    Target PostgreSQL table (required)
  -b    Number of rows per batch (default: 5000)
  -c    Columns to copy (optional)
  -o    COPY options (default: FORMAT CSV)
  -p    Number of parallel workers (default: 4)
  -h    Show this help message
```

## CSV

```sh
PG_HOST=localhost
PG_USER=postgres
PG_PASSWORD=postgres

postgres-parallel-copy -f example.csv -t example
```

