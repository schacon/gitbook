## Getting a Git Repository ##

So now that we're all set up, we need a Git repository. We can do this one of
two ways - we can *clone* one that already exists, or we can *initialize* one
either from existing files that aren't in source control yet, or from an empty
directory.

### Cloning a Repository ###

In order to get a copy of a project, you will need to know the project's Git
URL - the location of the repository. Git can operate over many different
protocols, so it may begin with ssh://, http(s)://, git://, or just a username
(in which case git will assume ssh). Some repositories may be accessed over
more than one protocol. For example, the source code to Git itself can be
cloned either over the git:// protocol:

    git clone git://git.kernel.org/pub/scm/git/git.git

or over http:

    git clone http://www.kernel.org/pub/scm/git/git.git

The git:// protocol is faster and more efficient, but sometimes it is
necessary to use http when behind corporate firewalls or what have you. In
either case you should then have a new directory named 'git' that contains all
the Git source code and history - it is basically a complete copy of what was
on the server.

By default, Git will name the new directory it has checked out your cloned
code into after whatever comes directly before the '.git' in the path of the
cloned project. (ie. *git clone
http://git.kernel.org/linux/kernel/git/torvalds/linux-2.6.git* will result in
a new directory named 'linux-2.6')

### Initializing a New Repository ###

Assume you have a tarball named project.tar.gz with your initial work. You can
place it under git revision control as follows.

    $ tar xzf project.tar.gz
    $ cd project
    $ git init

Git will reply

    Initialized empty Git repository in .git/

You've now initialized the working directory--you may notice a new
directory created, named ".git".

[gitcast:c1_init](GitCast #1 - setup, init and cloning)
