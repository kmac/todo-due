#!/bin/bash

MAILTO="<your email address>"
EMAIL_HEADER="todo.txt report"
#MARKDOWN="/usr/bin/markdown"
MARKDOWN=""

outfile=/tmp/due-cron.out

send_html_mail()
{
  (
  echo "To: $MAILTO"
  echo "Subject: $EMAIL_HEADER"
  echo "Content-Type: text/html"
  echo ""
  $MARKDOWN "$outfile"
  echo ""
  ) | /usr/sbin/sendmail -t
}

/usr/bin/todo.sh due > $outfile 2>&1
report=$(cat $outfile)
if [ ! -z "$report" ]; then
  if [ ! -z "$MARKDOWN" ]; then
    send_html_mail
  else
    cat $outfile | mail -s "$EMAIL_HEADER" "$MAILTO"
  fi
fi
