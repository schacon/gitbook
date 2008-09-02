### Git Config ###

The first thing you're going to want to do is set up your name and email
address for Git to use to sign your commits.

    $ git config --global user.name "Scott Chacon"
    $ git config --global user.email "schacon@gmail.com"

That will set up a file in your home directory which may be used by any of
your projects. By default that file is *~/.gitconfig* and the contents will
look like this:

    [user]
            name = Scott Chacon
            email = schacon@gmail.com
            
If you want to override those values for a specific project (to use a work
email address, for example), you can run the *git config* command without the
*--global* option while in that project. This will add a [user] section like
the one shown above to the *.git/config* file in your project's root
directory.
