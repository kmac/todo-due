Todo.txt 'due' addon
--------------------

This addon produces a report on todo items based on a field of the form: `due:yyyy-mm-dd`.

The report lists:

* overdue items
* due items (items due today)

The report is formatted as simple markdown text, suitable for sending via email or piping through a markdown script to generate HTML.

See the `due-cron-example.sh` script for an example script to be invoked via cron.


### Dependencies

You need python installed. Anything at or above 2.7 should work. It also works in 3.x.


### Usage

Copy the `due` script into your `$HOME/.todo.actions.d` directory (or wherever you have your addons configured). Ensure it's executable, then you can just use it as a standard todo.sh addon.

If there are no due/overdue items then there is no output. This is useful for scripting, e.g. for running a nightly cron to email the report.

Example:

    $ todo.sh due
    # Todo.txt Due Items
    
    Overdue
    -------
    
        (A) 2015-02-07 @home Schedule VISA payment due:2015-02-10
    
    Due Today
    ---------
    
        (C) @calls Call to book car maintenance due:2015-02-12
        (C) @work Submit TPS report due:2015-02-12
        (C) @home Take out the garbage due:2015-02-12


Other Scripts
-------------

### due-cron-example.sh

An example script for cron which generates a report of due items and sends it
via email.


### todo-add-due.sh

A script, intended to be run from cron, which adds an item with a generated
`due:` tag and optional generated  threshold `t:` tag. 

See crontab examples in the script header.


### todo2jrnl.sh

A script, inteded to be run from cron, which adds a summary of completed items
for the day into [jrnl][1]. Items are taken from the todo.tx file and the
archive file.

[1]: https://maebert.github.io/jrnl/

