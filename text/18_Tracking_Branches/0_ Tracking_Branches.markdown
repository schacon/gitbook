## Tracking Branches ##

A 'tracking branch' in Git is a local branch that is connected to a remote
branch.  When you push and pull on that branch, it automatically pushes and
pulls to the remote branch that it is connected with.

Use this if you always pull from the same upstream branch into the new 
branch, and if you don't want to use "git pull <repository> <refspec>" 
explicitly.

The 'git clone' command automatically sets up a 'master' branch that is
a tracking branch for 'origin/master' - the master branch on the cloned
repository.
	
You can create a tracking branch manually by adding the '--track' option
to the 'branch' command in Git. 

	git branch --track experimental origin/experimental

Then when you run:

	$ git pull experimental
	
It will automatically fetch from 'origin' and merge 'origin/experimental' 
into your local 'experimental' branch.

Likewise, when you push to origin, it will push what your 'experimental' points to
to origins 'experimental', without having to specify it.