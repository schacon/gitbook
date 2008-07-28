### Git Config ###

The first thing you're going to want to do is to setup your name and
email address for Git to use to sign your commits.

    $ git config --global user.name "Scott Chacon"
    $ git config --global user.email "schacon@gmail.com"

That will setup a file in your home directory that stores your name and email 
in any Git project where it's not overridden. By default that file is *~/.gitconfig*
and the contents will then look like this:

    [user]
            name = Scott Chacon
            email = schacon@gmail.com
            
If you want to override those values for a specific project (change to using a
work email address, for example), you can run the *git config* command without
the *--global* option while in that project.
