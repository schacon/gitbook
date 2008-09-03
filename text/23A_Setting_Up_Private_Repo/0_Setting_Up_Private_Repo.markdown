## Setting Up a Private Repository ##

If you need to setup a private repository and want to do so locally,
rather than using a hosted solution, you have a number of options.

### Repo Access over SSH ###

Generally, the easiest solution is to simply use Git over SSH.  If users
already have ssh accounts on a machine, you can put the git repository
anywhere on the box that they have access to and let them access it over
normal ssh logins.  For example, say you have a repository you want to 
host.  You can export it as a bare repo and then scp it onto your server
like so:
	
	$ git clone --bare /home/user/myrepo/.git /tmp/myrepo.git
	$ scp -r /tmp/myrepo.git myserver.com:/opt/git/myrepo.git
	
Then someone else with an ssh account on myserver.com can clone via:

	$ git clone myserver.com:/opt/git/myrepo.git

Which will simply prompt them for thier ssh password or use thier public key,
however they have ssh authentication setup.

### Multiple User Access using Gitosis ###

If you don't want to setup seperate accounts for every user, you can use
a tool called Gitosis.  In gitosis, there is an authorized_keys file that
contains the public keys of everyone authorized to access the repository,
and then everyone uses the 'git' user to do pushes and pulls.

[Installing and Setting up Gitosis](http://www.urbanpuddle.com/articles/2008/07/11/installing-git-on-a-server-ubuntu-or-debian)