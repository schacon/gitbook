## Rebasing ##

Suppose that you create a branch "mywork" on a remote-tracking branch
"origin", and create some commits on top of it:

    $ git checkout -b mywork origin
    $ vi file.txt
    $ git commit
    $ vi otherfile.txt
    $ git commit
    ...

You have performed no merges into mywork, so it is just a simple linear
sequence of patches on top of "origin":

    ................................................
     o--o--o <-- origin
            \
             o--o--o <-- mywork
    ................................................

Some more interesting work has been done in the upstream project, and
"origin" has advanced:

    ................................................
     o--o--O--o--o--o <-- origin
            \
             a--b--c <-- mywork
    ................................................

At this point, you could use "pull" to merge your changes back in;
the result would create a new merge commit, like this:

    ................................................
     o--o--O--o--o--o <-- origin
            \        \
             a--b--c--m <-- mywork
    ................................................

However, if you prefer to keep the history in mywork a simple series of
commits without any merges, you may instead choose to use
linkgit:git-rebase[1]:

    $ git checkout mywork
    $ git rebase origin

This will remove each of your commits from mywork, temporarily saving
them as patches (in a directory named ".git/rebase"), update mywork to
point at the latest version of origin, then apply each of the saved
patches to the new mywork.  The result will look like:

    ................................................
     o--o--O--o--o--o <-- origin
    		 \
    		  a'--b'--c' <-- mywork
    ................................................

In the process, it may discover conflicts.  In that case it will stop
and allow you to fix the conflicts; after fixing conflicts, use "git-add"
to update the index with those contents, and then, instead of
running git-commit, just run

    $ git rebase --continue

and git will continue applying the rest of the patches.

At any point you may use the `--abort` option to abort this process and
return mywork to the state it had before you started the rebase:

    $ git rebase --abort
