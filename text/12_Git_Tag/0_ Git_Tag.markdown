## Git Tag ##

We create a tag to refer to a particular commit; after running

    $ git tag stable-1 1b2e1d63ff
    
You can use stable-1 to refer to the commit 1b2e1d63ff.

This creates a "lightweight" tag.  If you would also like to include a
comment with the tag, and possibly sign it cryptographically, then you
should create a tag object instead; see the linkgit:git-tag[1] man page
for details.
