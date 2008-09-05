## Advanced Branching And Merging ##

### Getting conflict-resolution help during a merge ###

All of the changes that git was able to merge automatically are
already added to the index file, so linkgit:git-diff[1] shows only
the conflicts.  It uses an unusual syntax:

    $ git diff
    diff --cc file.txt
    index 802992c,2b60207..0000000
    --- a/file.txt
    +++ b/file.txt
    @@@ -1,1 -1,1 +1,5 @@@
    ++<<<<<<< HEAD:file.txt
     +Hello world
    ++=======
    + Goodbye
    ++>>>>>>> 77976da35a11db4580b80ae27e8d65caf5208086:file.txt

Recall that the commit which will be committed after we resolve this
conflict will have two parents instead of the usual one: one parent
will be HEAD, the tip of the current branch; the other will be the
tip of the other branch, which is stored temporarily in MERGE_HEAD.

During the merge, the index holds three versions of each file.  Each of
these three "file stages" represents a different version of the file:

	$ git show :1:file.txt	# the file in a common ancestor of both branches
	$ git show :2:file.txt	# the version from HEAD.
	$ git show :3:file.txt	# the version from MERGE_HEAD.

When you ask linkgit:git-diff[1] to show the conflicts, it runs a
three-way diff between the conflicted merge results in the work tree with
stages 2 and 3 to show only hunks whose contents come from both sides,
mixed (in other words, when a hunk's merge results come only from stage 2,
that part is not conflicting and is not shown.  Same for stage 3).

The diff above shows the differences between the working-tree version of
file.txt and the stage 2 and stage 3 versions.  So instead of preceding
each line by a single "+" or "-", it now uses two columns: the first
column is used for differences between the first parent and the working
directory copy, and the second for differences between the second parent
and the working directory copy.  (See the "COMBINED DIFF FORMAT" section
of linkgit:git-diff-files[1] for a details of the format.)

After resolving the conflict in the obvious way (but before updating the
index), the diff will look like:

    $ git diff
    diff --cc file.txt
    index 802992c,2b60207..0000000
    --- a/file.txt
    +++ b/file.txt
    @@@ -1,1 -1,1 +1,1 @@@
    - Hello world
    -Goodbye
    ++Goodbye world

This shows that our resolved version deleted "Hello world" from the
first parent, deleted "Goodbye" from the second parent, and added
"Goodbye world", which was previously absent from both.

Some special diff options allow diffing the working directory against
any of these stages:

    $ git diff -1 file.txt		# diff against stage 1
    $ git diff --base file.txt	# same as the above
    $ git diff -2 file.txt		# diff against stage 2
    $ git diff --ours file.txt	# same as the above
    $ git diff -3 file.txt		# diff against stage 3
    $ git diff --theirs file.txt	# same as the above.

The linkgit:git-log[1] and linkgit:gitk[1] commands also provide special help
for merges:

    $ git log --merge
    $ gitk --merge

These will display all commits which exist only on HEAD or on
MERGE_HEAD, and which touch an unmerged file.

You may also use linkgit:git-mergetool[1], which lets you merge the
unmerged files using external tools such as emacs or kdiff3.

Each time you resolve the conflicts in a file and update the index:

    $ git add file.txt

the different stages of that file will be "collapsed", after which
git-diff will (by default) no longer show diffs for that file.