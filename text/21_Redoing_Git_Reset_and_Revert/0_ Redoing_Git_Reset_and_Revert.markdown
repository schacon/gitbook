## Undoing in Git - Reset and Revert ##

If you've messed up the working tree, but haven't yet committed your
mistake, you can return the entire working tree to the last committed
state with

    $ git reset --hard HEAD

If you make a commit that you later wish you hadn't, there are two
fundamentally different ways to fix the problem:

1. You can create a new commit that undoes whatever was done
    by the old commit.  This is the correct thing if your
    mistake has already been made public.

2. You can go back and modify the old commit.  You should
    never do this if you have already made the history public;
    git does not normally expect the "history" of a project to
    change, and cannot correctly perform repeated merges from
    a branch that has had its history changed.


### Fixing a mistake with a new commit ###

Creating a new commit that reverts an earlier change is very easy;
just pass the linkgit:git-revert[1] command a reference to the bad
commit; for example, to revert the most recent commit:

    $ git revert HEAD

This will create a new commit which undoes the change in HEAD.  You
will be given a chance to edit the commit message for the new commit.

You can also revert an earlier change, for example, the next-to-last:

    $ git revert HEAD^

In this case git will attempt to undo the old change while leaving
intact any changes made since then.  If more recent changes overlap
with the changes to be reverted, then you will be asked to fix
conflicts manually, just as in the case of <<resolving-a-merge,
resolving a merge>>.