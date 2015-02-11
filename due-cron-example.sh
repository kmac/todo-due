#!/bin/bash

# This is a simple script to be invoked via cron. It runs `todo.sh due` and will send an email only if there are reported items.
# Usage:
#
# 1. Configure the MAILTO variable below
#
# 2. Setup cron. A sample crontabl entry:
# Send email at 6am:
# 0 6 * * *   /path/to/due-cron.sh > /tmp/cron-due.log 2>&1


# -- Configuration

# your email address
MAILTO="<your email addres>"

# path to todo.sh
TODO_SH=${TODO_SH:="/usr/bin/todo.sh"}

# path to markdown - leave blank to send text email
#MARKDOWN=""
MARKDOWN=${MARKDOWN:="/usr/bin/markdown"}

# the email header
EMAIL_HEADER="todo.txt report"

# path to sendmail
SENDMAIL=${SENDMAIL:="/usr/bin/sendmail"}

# -- End of configuration


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
  ) | $SENDMAIL -t
}

$TODO_SH due > $outfile 2>&1
report=$(cat $outfile)
if [ ! -z "$report" ]; then
  if [ ! -z "$MARKDOWN" ]; then
    send_html_mail
  else
    cat $outfile | mail -s "$EMAIL_HEADER" "$MAILTO"
  fi
fi
