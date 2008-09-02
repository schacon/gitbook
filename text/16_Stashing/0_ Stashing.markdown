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


### Stash Queue ###

You can also use stashing to queue up stashed changes.  
If you run 'git stash list' you can see which stashes you have saved:

	$>git stash list
	stash@{0}: WIP on book: 51bea1d... fixed images
	stash@{1}: WIP on master: 9705ae6... changed the browse code to the official repo

Then you can apply them individually with 'git stash apply stash@{1}'.  You
can clear out the list with 'git stash clear'.