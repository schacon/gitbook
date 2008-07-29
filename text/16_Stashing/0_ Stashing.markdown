## Stashing ##

While you are in the middle of working on something complicated, you
find an unrelated but obvious and trivial bug.  You would like to fix it
before continuing.  You can use linkgit:git-stash[1] to save the current
state of your work, and after fixing the bug (or, optionally after doing
so on a different branch and then coming back), unstash the
work-in-progress changes.

    $ git stash "work in progress for foo feature"

This command will save your changes away to the `stash`, and
reset your working tree and the index to match the tip of your
current branch.  Then you can make your fix as usual.

    ... edit and test ...
    $ git commit -a -m "blorpl: typofix"

After that, you can go back to what you were working on with
`git stash apply`:

    $ git stash apply

