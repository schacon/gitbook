## Git Directory and Working Directory ##

### The Git Directory ###

The 'git directory' is the directory that stores all Git's history and meta
information for your project - including all of the objects (commits, trees,
blobs, tags), all of the pointers to where different branches are and more.

There is only one Git Directory per project (as opposed to one per
subdirectory like with SVN or CVS), and that directory is (by default, though
not necessarily) '.git' in the root of your project.  If you look at the
contents of that directory, you can see all of your important files:

    $>tree -L 1
    .
    |-- HEAD         # pointer to your current branch
    |-- config       # your configuration preferences
    |-- description  # description of your project 
    |-- hooks/       # pre/post action hooks
    |-- index        # index file (see next section)
    |-- logs/        # a history of where your branches have been
    |-- objects/     # your objects (commits, trees, blobs, tags)
    `-- refs/        # pointers to your branches

(there may be some other files/directories in there as well, but they are not important for now)

### The Working Directory ###

The Git 'working directory' is the directory that holds the current checkout 
of the files you are working on.  Files in this directory are often removed
or replaced by Git as you switch branches - this is normal.  All your history 
is stored in the Git Directory; the working directory is simply a temporary 
checkout place where you can modify the files until your next commit.

