### Blob Object ###

A blob generally stores the contents of a file.

[fig:object-blob]

You can use linkgit:git-show[1] to examine the contents of any blob. 
Assuming we have the SHA for a blob, we can examine its contents like this:

    $ git show 6ff87c4664

     Note that the only valid version of the GPL as far as this project
     is concerned is _this_ particular version of the license (ie v2, not
     v2.2 or v3.x or whatever), unless explicitly otherwise stated.
    ...

A "blob" object is nothing but a chunk of binary data.  It doesn't refer
to anything else or have attributes of any kind, not even a file name.

Since the blob is entirely defined by its data, if two files in a
directory tree (or in multiple different versions of the repository)
have the same contents, they will share the same blob object. The object
is totally independent of its location in the directory tree, and
renaming a file does not change the object that file is associated with.

### Tree Object ###

A tree is a simple object that has a bunch of pointers to blobs and other
trees - it generally represents the contents of a directory or subdirectory.

[fig:object-tree]

The ever-versatile linkgit:git-show[1] command can also be used to
examine tree objects, but linkgit:git-ls-tree[1] will give you more
details.  Assuming we have the SHA for a tree, we can examine it like this:

    $ git ls-tree fb3a8bdd0ce
    100644 blob 63c918c667fa005ff12ad89437f2fdc80926e21c    .gitignore
    100644 blob 5529b198e8d14decbe4ad99db3f7fb632de0439d    .mailmap
    100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3    COPYING
    040000 tree 2fb783e477100ce076f6bf57e4a6f026013dc745    Documentation
    100755 blob 3c0032cec592a765692234f1cba47dfdcc3a9200    GIT-VERSION-GEN
    100644 blob 289b046a443c0647624607d471289b2c7dcd470b    INSTALL
    100644 blob 4eb463797adc693dc168b926b6932ff53f17d0b1    Makefile
    100644 blob 548142c327a6790ff8821d67c2ee1eff7a656b52    README
    ...

As you can see, a tree object contains a list of entries, each with a
mode, object type, SHA1 name, and name, sorted by name.  It represents
the contents of a single directory tree.

An object referenced by a tree may be blob, representing the contents of a
file, or another tree, representing the contents of a subdirectory.  Since
trees and blobs, like all other objects, are named by the SHA1 hash of their
contents, two trees have the same SHA1 name if and only if their contents
(including, recursively, the contents of all subdirectories) are identical.
This allows git to quickly determine the differences between two related tree
objects, since it can ignore any entries with identical object names.

(Note: in the presence of submodules, trees may also have commits as
entries.  See the **Submodules** section.)

Note that the files all have mode 644 or 755: git actually only pays
attention to the executable bit.

