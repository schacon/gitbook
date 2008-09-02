## Basic Branching and Merging ##

A single git repository can maintain multiple branches of
development.  To create a new branch named "experimental", use

    $ git branch experimental

If you now run

    $ git branch

you'll get a list of all existing branches:

      experimental
    * master

The "experimental" branch is the one you just created, and the
"master" branch is a default branch that was created for you
automatically.  The asterisk marks the branch you are currently on;
type

    $ git checkout experimental

to switch to the experimental branch.  Now edit a file, commit the
change, and switch back to the master branch:

    (edit file)
    $ git commit -a
    $ git checkout master

Check that the change you made is no longer visible, since it was
made on the experimental branch and you're back on the master branch.

You can make a different change on the master branch:

    (edit file)
    $ git commit -a

at this point the two branches have diverged, with different changes
made in each.  To merge the changes made in experimental into master, run

    $ git merge experimental

If the changes don't conflict, you're done.  If there are conflicts,
markers will be left in the problematic files showing the conflict;

    $ git diff

will show this.  Once you've edited the files to resolve the
conflicts,

    $ git commit -a

will commit the result of the merge. Finally,

    $ gitk

will show a nice graphical representation of the resulting history.

At this point you could delete the experimental branch with

    $ git branch -d experimental

This command ensures that the changes in the experimental branch are
already in the current branch.

If you develop on a branch crazy-idea, then regret it, you can always
delete the branch with

    $ git branch -D crazy-idea

Branches are cheap and easy, so this is a good way to try something
out.

### How to merge ###

You can rejoin two diverging branches of development using
linkgit:git-merge[1]:

    $ git merge branchname

merges the changes made in the branch "branchname" into the current
branch.  If there are conflicts--for example, if the same file is
modified in two different ways in the remote branch and the local
branch--then you are warned; the output may look something like this:

    $ git merge next
     100% (4/4) done
    Auto-merged file.txt
    CONFLICT (content): Merge conflict in file.txt
    Automatic merge failed; fix conflicts and then commit the result.

Conflict markers are left in the problematic files, and after
you resolve the conflicts manually, you can update the index
with the contents and run git commit, as you normally would when
modifying a file.

If you examine the resulting commit using gitk, you will see that it
has two parents: one pointing to the top of the current branch, and
one to the top of the other branch.

### Resolving a merge ###

When a merge isn't resolved automatically, git leaves the index and
the working tree in a special state that gives you all the
information you need to help resolve the merge.

Files with conflicts are marked specially in the index, so until you
resolve the problem and update the index, linkgit:git-commit[1] will
fail:

    $ git commit
    file.txt: needs merge

Also, linkgit:git-status[1] will list those files as "unmerged", and the
files with conflicts will have conflict markers added, like this:

    <<<<<<< HEAD:file.txt
    Hello world
    =======
    Goodbye
    >>>>>>> 77976da35a11db4580b80ae27e8d65caf5208086:file.txt

All you need to do is edit the files to resolve the conflicts, and then

    $ git add file.txt
    $ git commit

Note that the commit message will already be filled in for you with
some information about the merge.  Normally you can just use this
default message unchanged, but you may add additional commentary of
your own if desired.

The above is all you need to know to resolve a simple merge.  But git
also provides more information to help resolve conflicts:

### Undoing a merge ###

If you get stuck and decide to just give up and throw the whole mess
away, you can always return to the pre-merge state with

    $ git reset --hard HEAD

Or, if you've already committed the merge that you want to throw away,

    $ git reset --hard ORIG_HEAD

However, this last command can be dangerous in some cases--never throw away a
commit if that commit may itself have been merged into another branch, as
doing so may confuse further merges.

### Fast-forward merges ###

There is one special case not mentioned above, which is treated differently.
Normally, a merge results in a merge commit with two parents, one for each of
the two lines of development that were merged.

However, if the current branch has not diverged from the other--so every
commit present in the current branch is already contained in the other--then
git just performs a "fast forward"; the head of the current branch is moved
forward to point at the head of the merged-in branch, without any new commits
being created.

[gitcast:c6-branch-merge]("GitCast #6: Branching and Merging")
