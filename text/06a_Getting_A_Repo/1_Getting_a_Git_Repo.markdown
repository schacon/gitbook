## Getting a Git Repository ##

So now that we're all setup, we need a Git repository.  We can do this one of
two ways - we can *clone* one that already exists, or we can *initialize* one
either from existing files that aren't in source control yet, or just create 
a new project.

### Cloning a Repository ###

In order to get a copy of a project, you will need to know the projects Git 
URL - the location of the repository.  Git can operate over many different 
protocols, so it may begin with ssh://, http(s):// or git://, or just a username, 
in which case it will assume ssh.  Some repositories have more than one way to
clone it.  For example, the source code to Git itself can be cloned either through
the git:// protocol:

    git clone git://git.kernel.org/pub/scm/git/git.git

or over http:

    git clone http://www.kernel.org/pub/scm/git/git.git

The git:// protocol is faster and more efficient, but sometimes it is necceary 
to use the simpler http based one behind corporate firewalls or what have you. 
In either case you should then have a new directory named 'git' that contains
all the Git source code and history - it is basically a complete copy of what 
was on the server.

### Initializing a New Repository ###

Assume you have a tarball project.tar.gz with your initial work.  You
can place it under git revision control as follows.

    $ tar xzf project.tar.gz
    $ cd project
    $ git init

Git will reply

    Initialized empty Git repository in .git/

You've now initialized the working directory--you may notice a new
directory created, named ".git".

[gitcast:1](GitCast #1 - setup, init and cloning)