## Normal Workflow ##

Modify some files, then add their updated contents to the index:

    $ git add file1 file2 file3

You are now ready to commit.  You can see what is about to be committed
using linkgit:git-diff[1] with the --cached option:

    $ git diff --cached

(Without --cached, linkgit:git-diff[1] will show you any changes that
you've made but not yet added to the index.)  You can also get a brief
summary of the situation with linkgit:git-status[1]:

    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	modified:   file1
    #	modified:   file2
    #	modified:   file3
    #

If you need to make any further adjustments, do so now, and then add any
newly modified content to the index.  Finally, commit your changes with:

    $ git commit

This will again prompt you for a message describing the change, and then
record a new version of the project.

Alternatively, instead of running `git add` beforehand, you can use

    $ git commit -a
    
which will automatically notice any modified (but not new) files, add
them to the index, and commit, all in one step.

A note on commit messages: Though not required, it's a good idea to
begin the commit message with a single short (less than 50 character)
line summarizing the change, followed by a blank line and then a more
thorough description.  Tools that turn commits into email, for
example, use the first line on the Subject: line and the rest of the
commit message in the body.


#### Git tracks content not files ####

Many revision control systems provide an "add" command that tells the
system to start tracking changes to a new file.  Git's "add" command
does something simpler and more powerful: `git add` is used both for new
and newly modified files, and in both cases it takes a snapshot of the
given files and stages that content in the index, ready for inclusion in
the next commit.

[gitcast:c2_normal_workflow]("GitCast #2: Normal Workflow")