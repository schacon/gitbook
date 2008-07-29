## Reviewing History - Git Log ##

The linkgit:git-log[1] command can show lists of commits.  On its
own, it shows all commits reachable from the parent commit; but you
can also make more specific requests:

    $ git log v2.5..	# commits since (not reachable from) v2.5
    $ git log test..master	# commits reachable from master but not test
    $ git log master..test	# ...reachable from test but not master
    $ git log master...test	# ...reachable from either test or master,
    			#    but not both
    $ git log --since="2 weeks ago" # commits from the last 2 weeks
    $ git log Makefile      # commits which modify Makefile
    $ git log fs/		# ... which modify any file under fs/
    $ git log -S'foo()'	# commits which add or remove any file data
    			# matching the string 'foo()'

And of course you can combine all of these; the following finds
commits since v2.5 which touch the Makefile or any file under fs:

    $ git log v2.5.. Makefile fs/

You can also ask git log to show patches:

    $ git log -p

See the "--pretty" option in the linkgit:git-log[1] man page for more
display options.

Note that git log starts with the most recent commit and works
backwards through the parents; however, since git history can contain
multiple independent lines of development, the particular order that
commits are listed in may be somewhat arbitrary.
