## Comparing Commits - Git Diff ##

You can generate diffs between any two versions using
linkgit:git-diff[1]:

    $ git diff master..test

That will produce the diff between the tips of the two branches.  If
you'd prefer to find the diff from their common ancestor to test, you
can use three dots instead of two:

    $ git diff master...test

