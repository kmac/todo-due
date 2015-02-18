#!/bin/bash

help()
{
  printf "usage: $(basename $0) -d <days> ?-t? <days> <todo_item>\n"
  printf "\n   -d <days>: number of days until due\n"
  printf "\n   -t <days>: number of days until threshold (optional)\n"
  exit 1
}

# support --help even though getopts doesn't support long parameters
if [ "$1" = "--help" ]; then
  help
fi

DAYS_TO_DUE=
DAYS_TO_THRESHOLD=

while getopts hd:t: name; do
  case $name in
    d)
      DAYS_TO_DUE="$OPTARG"
      ;;
    t)
      DAYS_TO_THRESHOLD="$OPTARG"
      ;;
    h)
      help
      ;;
  esac
done
shift $(($OPTIND - 1))

if [ -z "$@" ]; then
  printf "ERROR: todo entry string is required\n"
  exit 1
fi

if [ -z "$DAYS_TO_DUE" ]; then
  printf "ERROR: -d <days> is required\n"
  exit 1
fi
DAYS_TO_DUE_VAL=$(date -d "+${DAYS_TO_DUE} days" +%Y-%m-%d)

DAYS_TO_THRESHOLD_STR=""
if [ ! -z "$DAYS_TO_THRESHOLD" ]; then
  d=$(date -d "+${DAYS_TO_THRESHOLD} days" +%Y-%m-%d)
  DAYS_TO_THRESHOLD_STR=" t:$d"
fi

/usr/bin/todo.sh add "$@ due:${DAYS_TO_DUE_VAL}${DAYS_TO_THRESHOLD_STR}"

