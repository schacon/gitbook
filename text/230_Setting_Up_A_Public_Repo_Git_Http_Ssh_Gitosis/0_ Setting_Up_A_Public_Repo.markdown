## Setting Up A Public Repository ##

Assume your personal repository is in the directory ~/proj.  We
first create a new clone of the repository and tell git-daemon that it
is meant to be public:

    $ git clone --bare ~/proj proj.git
    $ touch proj.git/git-daemon-export-ok

The resulting directory proj.git contains a "bare" git repository--it is
just the contents of the ".git" directory, without any files checked out
around it.

Next, copy proj.git to the server where you plan to host the
public repository.  You can use scp, rsync, or whatever is most
convenient.

### Exporting a git repository via the git protocol ###

This is the preferred method.

If someone else administers the server, they should tell you what
directory to put the repository in, and what git:// URL it will appear
at.

Otherwise, all you need to do is start linkgit:git-daemon[1]; it will
listen on port 9418.  By default, it will allow access to any directory
that looks like a git directory and contains the magic file
git-daemon-export-ok.  Passing some directory paths as git-daemon
arguments will further restrict the exports to those paths.

You can also run git-daemon as an inetd service; see the
linkgit:git-daemon[1] man page for details.  (See especially the
examples section.)

### Exporting a git repository via http ###

The git protocol gives better performance and reliability, but on a
host with a web server set up, http exports may be simpler to set up.

All you need to do is place the newly created bare git repository in
a directory that is exported by the web server, and make some
adjustments to give web clients some extra information they need:

    $ mv proj.git /home/you/public_html/proj.git
    $ cd proj.git
    $ git --bare update-server-info
    $ chmod a+x hooks/post-update

(For an explanation of the last two lines, see
linkgit:git-update-server-info[1] and linkgit:githooks[5].)

Advertise the URL of proj.git.  Anybody else should then be able to
clone or pull from that URL, for example with a command line like:

    $ git clone http://yourserver.com/~you/proj.git
