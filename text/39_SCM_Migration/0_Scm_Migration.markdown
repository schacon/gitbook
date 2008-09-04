## SCM Migration ##

So you've made the decision to move away from your existing system
and convert your whole project to Git.  How can you do that easily?

### Importing Subversion ###

Git comes with a script called git-svn that has a clone command that
will import a subversion repository into a new git repository.  There
is also a free tool on the GitHub service that will do this for you.
	
	$ git-svn clone http://my-project.googlecode.com/svn/trunk new-project

This will give you a new Git repository with all the history of the
original Subversion repo.  This takes a pretty good amount of time, generally,
since it starts with version 1 and checks out and commits locally every
single revision one by one.

### Importing Perforce ###

In contrib/fast-import you will find the git-p4 script, which is a 
Python script that will import a Perforce repository for you.

	$ ~/git.git/contrib/fast-import/git-p4 clone //depot/project/main@all myproject
	

### Importing Others ###

These are other SCMs that listed high on the Git Survey, should find import
docs for them.  !!TODO!!

* CVS
* Mercurial (hg)

* Bazaar-NG
* Darcs
* ClearCase
	
