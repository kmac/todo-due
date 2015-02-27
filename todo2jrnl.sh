#!/bin/bash

TODO_DIR=${TODO_DIR:-"$HOME/Dropbox/todo"}
TODO_FILE="${TODO_FILE:-$TODO_DIR/todo.txt}"
ARCHIVE_FILE="${ARCHIVE_FILE:-$TODO_DIR/done.txt}"
JRNL=${JRNL:-/usr/bin/jrnl}

help()
{
cat <<HELP
usage: $(basename $0) <-d|--dry-run>

options:
    -d|--dry-run  : dry-run, doesn't invoke jrnl

This script adds any items completed today to [jrnl]

[jrnl]: https://maebert.github.io/jrnl/

It checks both TODO_FILE and ARCHIVE_FILE:

TODO_FILE=${TODO_FILE}
ARCHIVE_FILE=${ARCHIVE_FILE}
HELP
  exit 1
}

ARG_DRY_RUN=
while [ $# -gt 0 ] ; do
    case "$1" in
    -h|--help)
      help
      ;;
    -d|--dry-run)
      ARG_DRY_RUN=1
      ;;
    * ) printf "error, unknown argument: $1\n"
        exit 192
        ;;
    esac
    shift
done

if [ ! -x "$JRNL" ]; then
  printf "ERROR: jrnl command not available: JRNL=$JRNL\n"
  exit 1
fi
if [ ! -f "$TODO_FILE" ]; then
  printf "ERROR: TODO_FILE not found: ARCHIVE_FILE=$TODO_FILE\n"
  exit 1
fi
if [ ! -f "$ARCHIVE_FILE" ]; then
  printf "ERROR: ARCHIVE_FILE not found: ARCHIVE_FILE=$ARCHIVE_FILE\n"
  exit 1
fi

todaystr=$(date +%Y-%m-%d)
done_today=$(grep "x $todaystr" $TODO_FILE)
archived_today=$(grep "x $todaystr" $ARCHIVE_FILE)

if [ ! -z "$done_today" ] || [ ! -z "$archived_today" ]; then
  summary="Summary of todo.sh completions:\n"
  if [ ! -z "$done_today" ]; then
    summary="${summary}${done_today}"
  fi
  if [ ! -z "$archived_today" ]; then
    summary="${summary}\n${archived_today}"
  fi
  printf "$summary\n"
  if [ -z "$ARG_DRY_RUN" ]; then
    printf "$summary\n" | "$JRNL"
  fi
else
  printf "Nothing completed today\n"
fi
