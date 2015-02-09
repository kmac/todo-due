#!/bin/bash

# your email address
MAILTO="<your email addres>"

# the email header
EMAIL_HEADER="todo.txt report"

# path to markdown - leave blank to send text email
#MARKDOWN=""
MARKDOWN="/usr/bin/markdown"


outfile=/tmp/due-cron.out

send_html_mail()
{
  # sends html email - this is the most portable way I could find
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
