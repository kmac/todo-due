#!/bin/bash

help()
{
cat <<HELP
usage: $(basename $0) -d <days> ?-t? <days> <todo_item>

options:
   -d <days>: number of days until due
   -t <days>: number of days until threshold (optional)

This script adds a todo item to be due in a specified number of days.

You can invoke this script from cron to schedule periodic todo items.
 

An example set of crontab entries
NOTE: it's probably a good idea to make sure none of these run at the same time:

# todo.sh recurring items: Note: make sure none of these run at the same time
1 4 * * 2  /somepath/todo-due/todo-add-due.sh -d 0 "(C) @home Take out the trash" > /tmp/todo.sh.log 2>&1
0 4 12 * *  /somepath/todo-due/todo-add-due.sh -d 5 -t 2 "(B) @computer Schedule VISA payment" > /tmp/todo.sh.log 2>&1
0 4 1 * *  /somepath/todo-due/todo-add-due.sh -d 0 "@work Archive monthly email" > /tmp/todo.sh.log 2>&1
5 4 1 1,3,6,9 *  /somepath/todo-due/todo-add-due.sh -d 0 "@work Cleanup downloaded packages" > /tmp/todo.sh.log 2>&1

HELP
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

