## The Git Object Database ##

We already saw in <<understanding-commits>> that all commits are stored
under a 40-digit "object name".  In fact, all the information needed to
represent the history of a project is stored in objects with such names.
In each case the name is calculated by taking the SHA1 hash of the
contents of the object.  The SHA1 hash is a cryptographic hash function.
What that means to us is that it is impossible to find two different
objects with the same name.  This has a number of advantages; among
others:

- Git can quickly determine whether two objects are identical or not,
  just by comparing names.
- Since object names are computed the same way in every repository, the
  same content stored in two repositories will always be stored under
  the same name.
- Git can detect errors when it reads an object, by checking that the
  object's name is still the SHA1 hash of its contents.

(See <<object-details>> for the details of the object formatting and
SHA1 calculation.)

There are four different types of objects: "blob", "tree", "commit", and
"tag".

- A <<def_blob_object,"blob" object>> is used to store file data.
- A <<def_tree_object,"tree" object>> ties one or more
  "blob" objects into a directory structure. In addition, a tree object
  can refer to other tree objects, thus creating a directory hierarchy.
- A <<def_commit_object,"commit" object>> ties such directory hierarchies
  together into a <<def_DAG,directed acyclic graph>> of revisions--each
  commit contains the object name of exactly one tree designating the
  directory hierarchy at the time of the commit. In addition, a commit
  refers to "parent" commit objects that describe the history of how we
  arrived at that directory hierarchy.
- A <<def_tag_object,"tag" object>> symbolically identifies and can be
  used to sign other objects. It contains the object name and type of
  another object, a symbolic name (of course!) and, optionally, a
  signature.

The object types in some more detail: