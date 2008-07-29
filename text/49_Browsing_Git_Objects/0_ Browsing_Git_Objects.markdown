## Browsing Git Objects ##

We can ask git about particular objects with the cat-file
command. Note that you can shorten the shas to only a few
characters to save yourself typing all 40 hex digits:

    $ git-cat-file -t 54196cc2
    commit
    $ git-cat-file commit 54196cc2
    tree 92b8b694ffb1675e5975148e1121810081dbdffe
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500

    initial commit

A tree can refer to one or more "blob" objects, each corresponding to
a file.  In addition, a tree can also refer to other tree objects,
thus creating a directory hierarchy.  You can examine the contents of
any tree using ls-tree (remember that a long enough initial portion
of the SHA1 will also work):

    $ git ls-tree 92b8b694
    100644 blob 3b18e512dba79e4c8300dd08aeb37f8e728b8dad    file.txt

Thus we see that this tree has one file in it.  The SHA1 hash is a
reference to that file's data:

    $ git cat-file -t 3b18e512
    blob

A "blob" is just file data, which we can also examine with cat-file:

    $ git cat-file blob 3b18e512
    hello world

Note that this is the old file data; so the object that git named in
its response to the initial tree was a tree with a snapshot of the
directory state that was recorded by the first commit.

All of these objects are stored under their SHA1 names inside the git
directory:

    $ find .git/objects/
    .git/objects/
    .git/objects/pack
    .git/objects/info
    .git/objects/3b
    .git/objects/3b/18e512dba79e4c8300dd08aeb37f8e728b8dad
    .git/objects/92
    .git/objects/92/b8b694ffb1675e5975148e1121810081dbdffe
    .git/objects/54
    .git/objects/54/196cc2703dc165cbd373a65a4dcf22d50ae7f7
    .git/objects/a0
    .git/objects/a0/423896973644771497bdc03eb99d5281615b51
    .git/objects/d0
    .git/objects/d0/492b368b66bdabf2ac1fd8c92b39d3db916e59
    .git/objects/c4
    .git/objects/c4/d59f390b9cfd4318117afde11d601c1085f241

and the contents of these files is just the compressed data plus a
header identifying their length and their type.  The type is either a
blob, a tree, a commit, or a tag.

The simplest commit to find is the HEAD commit, which we can find
from .git/HEAD:

    $ cat .git/HEAD
    ref: refs/heads/master

As you can see, this tells us which branch we're currently on, and it
tells us this by naming a file under the .git directory, which itself
contains a SHA1 name referring to a commit object, which we can
examine with cat-file:

    $ cat .git/refs/heads/master
    c4d59f390b9cfd4318117afde11d601c1085f241
    $ git cat-file -t c4d59f39
    commit
    $ git cat-file commit c4d59f39
    tree d0492b368b66bdabf2ac1fd8c92b39d3db916e59
    parent 54196cc2703dc165cbd373a65a4dcf22d50ae7f7
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143418702 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143418702 -0500

    add emphasis

The "tree" object here refers to the new state of the tree:

    $ git ls-tree d0492b36
    100644 blob a0423896973644771497bdc03eb99d5281615b51    file.txt
    $ git cat-file blob a0423896
    hello world!

and the "parent" object refers to the previous commit:

    $ git-cat-file commit 54196cc2
    tree 92b8b694ffb1675e5975148e1121810081dbdffe
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
