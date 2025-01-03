#!/usr/bin/env bash

. ./../lib/utils.sh

usage() {
  cat <<EOF
Usage: $0 -f <file> -t <table> [-b <batch_size>] [-c <columns>] [-o <options>] [-p <max_parallel>]

Options:  
  -f    Input file containing rows to copy (required)
  -t    Target PostgreSQL table (required)
  -b    Number of rows per batch (default: 5000)
  -c    Columns to copy (optional)
  -o    COPY options (default: CSV)
  -p    Number of parallel workers (default: 4)
  -h    Show this help message
EOF
}

main() {
  local batch_size=5000
  local max_parallel=4
  local options="FORMAT CSV"
  local columns temp_dir

  while getopts ":f:t:b:c:o:p:h" opt; do
    case "$opt" in
      f) file="$OPTARG" ;;
      t) table="$OPTARG" ;;
      b) batch_size="$OPTARG" ;;
      c) columns="$OPTARG" ;;
      o) options="$OPTARG" ;;
      p) max_parallel="$OPTARG" ;;
      h) usage; exit 0 ;;
      *) usage; exit 1 ;;
    esac
  done

  : "${file:?Missing required <file> argument}"
  : "${table:?Missing required <table> argument}"

  if is_set "$columns"; then
    columns="(${columns})"
  fi

  temp_dir=$(mktemp -d)
  trap 'rm -rf "$temp_dir"' EXIT

  file_split "$file" "${temp_dir%/}/" "$batch_size" | {
    parallel -j "$max_parallel" \
    "psql -c 'COPY ${table} ${columns} FROM STDIN WITH (${options})' < {}"
  }
}

main "$@"
