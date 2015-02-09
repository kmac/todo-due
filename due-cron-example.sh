#!/bin/bash

MAILTO=<your email address>

report=$(/usr/bin/todo.sh due)
if [ ! -z "$report" ]; then
  echo $report | mail -v -s "todo.txt due $(date)" "$MAILTO"
fi
