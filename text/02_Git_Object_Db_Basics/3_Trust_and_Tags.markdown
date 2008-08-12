
### Tag Object ###

[fig:object-tag]

A tag object contains an object name (called simply 'object'), object type,
tag name, the name of the person ("tagger") who created the tag, and a
message, which may contain a signature, as can be seen using
linkgit:git-cat-file[1]:

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
