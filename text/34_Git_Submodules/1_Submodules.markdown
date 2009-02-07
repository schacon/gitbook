## Submodules ##

Large projects are often composed of smaller, self-contained modules.  For
example, an embedded Linux distribution's source tree would include every
piece of software in the distribution with some local modifications; a movie
player might need to build against a specific, known-working version of a
decompression library; several independent programs might all share the same
build scripts.

With centralized revision control systems this is often accomplished by
including every module in one single repository.  Developers can check out
all modules or only the modules they need to work with.  They can even modify
files across several modules in a single commit while moving things around
or updating APIs and translations.

Git does not allow partial checkouts, so duplicating this approach in Git
would force developers to keep a local copy of modules they are not
interested in touching.  Commits in an enormous checkout would be slower
than you'd expect as Git would have to scan every directory for changes.
If modules have a lot of local history, clones would take forever.

On the plus side, distributed revision control systems can much better
integrate with external sources.  In a centralized model, a single arbitrary
snapshot of the external project is exported from its own revision control
and then imported into the local revision control on a vendor branch.  All
the history is hidden.  With distributed revision control you can clone the
entire external history and much more easily follow development and re-merge
local changes.

Git's submodule support allows a repository to contain, as a subdirectory, a
checkout of an external project.  Submodules maintain their own identity;
the submodule support just stores the submodule repository location and
commit ID, so other developers who clone the containing project
("superproject") can easily clone all the submodules at the same revision.
Partial checkouts of the superproject are possible: you can tell Git to
clone none, some or all of the submodules.

The linkgit:git-submodule[1] command is available since Git 1.5.3.  Users
with Git 1.5.2 can look up the submodule commits in the repository and
manually check them out; earlier versions won't recognize the submodules at
all.

To see how submodule support works, create (for example) four example
repositories that can be used later as a submodule:

    $ mkdir ~/git
    $ cd ~/git
    $ for i in a b c d
    do
        mkdir $i
	    cd $i
	    git init
	    echo "module $i" > $i.txt
	    git add $i.txt
	    git commit -m "Initial commit, submodule $i"
	    cd ..
    done

Now create the superproject and add all the submodules:

    $ mkdir super
    $ cd super
    $ git init
    $ for i in a b c d
    do
        git submodule add ~/git/$i $i
    done

NOTE: Do not use local URLs here if you plan to publish your superproject!

See what files `git-submodule` created:

    $ ls -a
    .  ..  .git  .gitmodules  a  b  c  d

The `git-submodule add` command does a couple of things:

- It clones the submodule under the current directory and by default checks out
  the master branch.
- It adds the submodule's clone path to the linkgit:gitmodules[5] file and
  adds this file to the index, ready to be committed.
- It adds the submodule's current commit ID to the index, ready to be
  committed.

Commit the superproject:


    $ git commit -m "Add submodules a, b, c and d."

Now clone the superproject:

    $ cd ..
    $ git clone super cloned
    $ cd cloned

The submodule directories are there, but they're empty:

    $ ls -a a
    .  ..
    $ git submodule status
    -d266b9873ad50488163457f025db7cdd9683d88b a
    -e81d457da15309b4fef4249aba9b50187999670d b
    -c1536a972b9affea0f16e0680ba87332dc059146 c
    -d96249ff5d57de5de093e6baff9e0aafa5276a74 d

NOTE: The commit object names shown above would be different for you, but they
should match the HEAD commit object names of your repositories.  You can check
it by running `git ls-remote ../git/a`.

Pulling down the submodules is a two-step process. First run `git submodule
init` to add the submodule repository URLs to `.git/config`:

    $ git submodule init

Now use `git-submodule update` to clone the repositories and check out the
commits specified in the superproject:

    $ git submodule update
    $ cd a
    $ ls -a
    .  ..  .git  a.txt

One major difference between `git-submodule update` and `git-submodule add` is
that `git-submodule update` checks out a specific commit, rather than the tip
of a branch. It's like checking out a tag: the head is detached, so you're not
working on a branch.

    $ git branch
    * (no branch)
    master

If you want to make a change within a submodule and you have a detached head,
then you should create or checkout a branch, make your changes, publish the
change within the submodule, and then update the superproject to reference the
new commit:

    $ git checkout master

or

    $ git checkout -b fix-up

then

    $ echo "adding a line again" >> a.txt
    $ git commit -a -m "Updated the submodule from within the superproject."
    $ git push
    $ cd ..
    $ git diff
    diff --git a/a b/a
    index d266b98..261dfac 160000
    --- a/a
    +++ b/a
    @@ -1 +1 @@
    -Subproject commit d266b9873ad50488163457f025db7cdd9683d88b
    +Subproject commit 261dfac35cb99d380eb966e102c1197139f7fa24
    $ git add a
    $ git commit -m "Updated submodule a."
    $ git push

You have to run `git submodule update` after `git pull` if you want to update
submodules, too.

###Pitfalls with submodules

Always publish the submodule change before publishing the change to the
superproject that references it. If you forget to publish the submodule change,
others won't be able to clone the repository:

    $ cd ~/git/super/a
    $ echo i added another line to this file >> a.txt
    $ git commit -a -m "doing it wrong this time"
    $ cd ..
    $ git add a
    $ git commit -m "Updated submodule a again."
    $ git push
    $ cd ~/git/cloned
    $ git pull
    $ git submodule update
    error: pathspec '261dfac35cb99d380eb966e102c1197139f7fa24' did not match any file(s) known to git.
    Did you forget to 'git add'?
    Unable to checkout '261dfac35cb99d380eb966e102c1197139f7fa24' in submodule path 'a'

If you are staging an updated submodule for commit manually, be careful to not
add a trailing slash when specifying the path. With the slash appended, Git
will assume you are removing the submodule and checking that directory's
contents into the containing repository.

    $ cd ~/git/super/a
    $ echo i added another line to this file >> a.txt
    $ git commit -a -m "doing it wrong this time"
    $ cd ..
    $ git add a/
    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       deleted:    a
    #       new file:   a/a.txt
    #
    # Modified submodules:
    #
    # * a aa5c351...0000000 (1):
    #   < Initial commit, submodule a
    #

To fix the index after performing this operation, reset the changes and then
add the submodule without the trailing slash.

    $ git reset HEAD A
    $ git add a
    $ git status
    # On branch master
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #       modified:   a
    #
    # Modified submodules:
    #
    # * a aa5c351...8d3ba36 (1):
    #   > doing it wrong this time
    #

You also should not rewind branches in a submodule beyond commits that were
ever recorded in any superproject.

It's not safe to run `git submodule update` if you've made and committed
changes within a submodule without checking out a branch first. They will be
silently overwritten:

    $ cat a.txt
    module a
    $ echo line added from private2 >> a.txt
    $ git commit -a -m "line added inside private2"
    $ cd ..
    $ git submodule update
    Submodule path 'a': checked out 'd266b9873ad50488163457f025db7cdd9683d88b'
    $ cd a
    $ cat a.txt
    module a

NOTE: The changes are still visible in the submodule's reflog.

This is not the case if you did not commit your changes.

[gitcast:c11-git-submodules]("GitCast #11: Git Submodules")
