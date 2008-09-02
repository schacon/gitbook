## Interactive Rebasing ##

You can also rebase interactively.  This is often used to re-write your
own commit objects before pusing them somewhere.  It is an easy way to 
split, merge or re-order commits before sharing them with others.  You
can also use it to clean up commits you've pulled from someone when
applying them locally.

If you have a number of commits that you would like to somehow modify
during the rebase, you can invoke interactive mode by passing a '-i' or
'--interactive' to the 'git rebase' command.

	$ git rebase -i origin/master
	
This will invoke interactive rebase mode on all the commits you have made
since the last time you have pushed (or merged from the origin repository).

To see what commits those are beforehand, you can run log this way:
	
	$ git log github/master..
	
Once you run the 'rebase -i' command, you will be thrown into your editor
of choice with something that looks like this:

	pick fc62e55 added file_size
	pick 9824bf4 fixed little thing
	pick 21d80a5 added number to log
	pick 76b9da6 added the apply command
	pick c264051 Revert "added file_size" - not implemented correctly

	# Rebase f408319..b04dc3d onto f408319
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

This means that there are 5 commits since you last pushed and it gives you 
one line per commit with the following format:

	(action) (partial-sha) (short commit message)
	
Now, you can change the action (which is by default 'pick') to either 'edit'
or 'squash', or just leave it as 'pick'.  You can also reorder the commits
just by moving the lines around however you want.  Then, when you exit the 
editor, git will try to apply the commits however they are now arranged and
do the action specified. 

If 'pick' is specified, it will simply try to apply the patch and save the 
commit with the same message as before.

If 'squash' is specified, it will combine that commit with the previous one
to create a new commit.  This will drop you into your editor again to merge
the commit messages of the two commits it is now squashing together.  So, 
if you exit the editor with this:

	pick   fc62e55 added file_size
	squash 9824bf4 fixed little thing
	squash 21d80a5 added number to log
	squash 76b9da6 added the apply command
	squash c264051 Revert "added file_size" - not implemented correctly

Then you will have to create a single commit message from this:

	# This is a combination of 5 commits.
	# The first commit's message is:
	added file_size

	# This is the 2nd commit message:

	fixed little thing

	# This is the 3rd commit message:

	added number to log

	# This is the 4th commit message:

	added the apply command

	# This is the 5th commit message:

	Revert "added file_size" - not implemented correctly

	This reverts commit fc62e5543b195f18391886b9f663d5a7eca38e84.

Once you have edited that down into once commit message and exit the editor,
the commit will be saved with your new message.

If 'edit' is specified, it will do the same thing, but then pause before 
moving on to the next one and drop you into the command line so you can 
amend the commit, or change the commit contents somehow.

If you wanted to split a commit, for instance, you would specify 'edit' for
that commit:

	pick   fc62e55 added file_size
	pick   9824bf4 fixed little thing
	edit   21d80a5 added number to log
	pick   76b9da6 added the apply command
	pick   c264051 Revert "added file_size" - not implemented correctly

And then when you get to the command line, you revert that commit and create
two (or more) new ones.  Lets say 21d80a5 modified two files, file1 and file2,
and you wanted to split them into seperate commits.  You could do this after
the rebase dropped you to the command line :

	$ git reset HEAD^
	$ git add file1
	$ git commit 'first part of split commit'
	$ git add file2
	$ git commit 'second part of split commit'
	$ git rebase --continue
	
And now instead of 5 commits, you would have 6.

The last useful thing that interactive rebase can do is drop commits for you.
If instead of choosing 'pick', 'squash' or 'edit' for the commit line, you 
simply remove the line, it will remove the commit from the history.