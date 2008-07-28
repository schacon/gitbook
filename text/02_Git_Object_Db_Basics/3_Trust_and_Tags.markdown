### Trust ###

If you receive the SHA1 name of a blob from one source, and its contents
from another (possibly untrusted) source, you can still trust that those
contents are correct as long as the SHA1 name agrees.  This is because
the SHA1 is designed so that it is infeasible to find different contents
that produce the same hash.

Similarly, you need only trust the SHA1 name of a top-level tree object
to trust the contents of the entire directory that it refers to, and if
you receive the SHA1 name of a commit from a trusted source, then you
can easily verify the entire history of commits reachable through
parents of that commit, and all of those contents of the trees referred
to by those commits.

So to introduce some real trust in the system, the only thing you need
to do is to digitally sign just 'one' special note, which includes the
name of a top-level commit.  Your digital signature shows others
that you trust that commit, and the immutability of the history of
commits tells others that they can trust the whole history.

In other words, you can easily validate a whole archive by just
sending out a single email that tells the people the name (SHA1 hash)
of the top commit, and digitally sign that email using something
like GPG/PGP.

To assist in this, git also provides the tag object...

### Tag Object ###

A tag object contains an object, object type, tag name, the name of the
person ("tagger") who created the tag, and a message, which may contain
a signature, as can be seen using linkgit:git-cat-file[1]:

    $ git cat-file tag v1.5.0
    object 437b1b20df4b356c9342dac8d38849f24ef44f27
    type commit
    tag v1.5.0
    tagger Junio C Hamano <junkio@cox.net> 1171411200 +0000

    GIT 1.5.0
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.6 (GNU/Linux)

    iD8DBQBF0lGqwMbZpPMRm5oRAuRiAJ9ohBLd7s2kqjkKlq1qqC57SbnmzQCdG4ui
    nLE/L9aUXdWeTFPron96DLA=
    =2E+0
    -----END PGP SIGNATURE-----

See the linkgit:git-tag[1] command to learn how to create and verify tag
objects.  (Note that linkgit:git-tag[1] can also be used to create
"lightweight tags", which are not tag objects at all, but just simple
references whose names begin with "refs/tags/").
