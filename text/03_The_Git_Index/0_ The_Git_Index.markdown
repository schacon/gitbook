## The Git Index ##

The Git index is used as a staging area between your working directory 
and your repository.  You can use the index to build up a set of changes
that you want to commit together.  When you create a commit, what is committed
is what is currently in the index, not what is in your working directory.

### Looking at the Index ###

The easiest way to see what is in the index is with the linkgit:git-status[1]
command.  When you run git status, you can see which files are staged
(currently in your index), which are modified but not yet staged, and which
are completely untracked.

    $>git status
    # On branch master
    # Your branch is behind 'origin/master' by 11 commits, and can be fast-forwarded.
    #
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	modified:   daemon.c
    #
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #
    #	modified:   grep.c
    #	modified:   grep.h
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #	blametree
    #	blametree-init
    #	git-gui/git-citool

If you blow the index away entirely, you generally haven't lost any
information as long as you have the name of the tree that it described.

And with that, you should have a pretty good understanding of the basics of 
what Git is doing behind the scenes, and why it is a bit different than most
other SCM systems.  Don't worry if you don't totally understand it all right 
now; we'll revisit all of these topics in the next sections. Now we're ready 
to move on to installing, configuring and using Git.  