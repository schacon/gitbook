## The Git Index ##

The index is a binary file (generally kept in .git/index) containing a
sorted list of path names, each with permissions and the SHA1 of a blob
object; linkgit:git-ls-files[1] can show you the contents of the index:

    $ git ls-files --stage
    100644 63c918c667fa005ff12ad89437f2fdc80926e21c 0	.gitignore
    100644 5529b198e8d14decbe4ad99db3f7fb632de0439d 0	.mailmap
    100644 6ff87c4664981e4397625791c8ea3bbb5f2279a3 0	COPYING
    100644 a37b2152bd26be2c2289e1f57a292534a51a93c7 0	Documentation/.gitignore
    100644 fbefe9a45b00a54b58d94d06eca48b03d40a50e0 0	Documentation/Makefile
    ...
    100644 2511aef8d89ab52be5ec6a5e46236b4b6bcd07ea 0	xdiff/xtypes.h
    100644 2ade97b2574a9f77e7ae4002a4e07a6a38e46d07 0	xdiff/xutils.c
    100644 d5de8292e05e7c36c4b68857c1cf9855e3d2f70a 0	xdiff/xutils.h

Note that in older documentation you may see the index called the
"current directory cache" or just the "cache".  It has three important
properties:

1. The index contains all the information necessary to generate a single
    (uniquely determined) tree object.

    For example, running linkgit:git-commit[1] generates this tree object
    from the index, stores it in the object database, and uses it as the
    tree object associated with the new commit.

2. The index enables fast comparisons between the tree object it defines
    and the working tree.

    It does this by storing some additional data for each entry (such as
    the last modified time).  This data is not displayed above, and is not
    stored in the created tree object, but it can be used to determine
    quickly which files in the working directory differ from what was
    stored in the index, and thus save git from having to read all of the
    data from such files to look for changes.

3. It can efficiently represent information about merge conflicts
    between different tree objects, allowing each pathname to be
    associated with sufficient information about the trees involved that
    you can create a three-way merge between them.

    During a merge, the index can
    store multiple versions of a single file (called "stages").  The third
    column in the linkgit:git-ls-files[1] output above is the stage
    number, and will take on values other than 0 for files with merge
    conflicts.

The index is thus a sort of temporary staging area, which is filled with
a tree which you are in the process of working on.
