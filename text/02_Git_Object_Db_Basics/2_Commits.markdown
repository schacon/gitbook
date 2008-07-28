### Commit Object ###

The "commit" object links a physical state of a tree with a description
of how we got there and why.  Use the --pretty=raw option to
linkgit:git-show[1] or linkgit:git-log[1] to examine your favorite
commit:

    $ git show -s --pretty=raw 2be7fcb476
    commit 2be7fcb4764f2dbcee52635b91fedb1b3dcf7ab4
    tree fb3a8bdd0ceddd019615af4d57a53f43d8cee2bf
    parent 257a84d9d02e90447b149af58b271c19405edb6a
    author Dave Watson <dwatson@mimvista.com> 1187576872 -0400
    committer Junio C Hamano <gitster@pobox.com> 1187591163 -0700

        Fix misspelling of 'suppress' in docs

        Signed-off-by: Junio C Hamano <gitster@pobox.com>

As you can see, a commit is defined by:

- a tree: The SHA1 name of a tree object (as defined below), representing
  the contents of a directory at a certain point in time.
- parent(s): The SHA1 name of some number of commits which represent the
  immediately previous step(s) in the history of the project.  The
  example above has one parent; merge commits may have more than
  one.  A commit with no parents is called a "root" commit, and
  represents the initial revision of a project.  Each project must have
  at least one root.  A project can also have multiple roots, though
  that isn't common (or necessarily a good idea).
- an author: The name of the person responsible for this change, together
  with its date.
- a committer: The name of the person who actually created the commit,
  with the date it was done.  This may be different from the author, for
  example, if the author was someone who wrote a patch and emailed it
  to the person who used it to create the commit.
- a comment describing this commit.

Note that a commit does not itself contain any information about what
actually changed; all changes are calculated by comparing the contents
of the tree referred to by this commit with the trees associated with
its parents.  In particular, git does not attempt to record file renames
explicitly, though it can identify cases where the existence of the same
file data at changing paths suggests a rename.  (See, for example, the
-M option to linkgit:git-diff[1]).

A commit is usually created by linkgit:git-commit[1], which creates a
commit whose parent is normally the current HEAD, and whose tree is
taken from the content currently stored in the index.
