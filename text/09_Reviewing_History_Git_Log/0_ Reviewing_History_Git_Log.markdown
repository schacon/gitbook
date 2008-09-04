## Reviewing History - Git Log ##

The linkgit:git-log[1] command can show lists of commits.  On its
own, it shows all commits reachable from the parent commit; but you
can also make more specific requests:

    $ git log v2.5..	    # commits since (not reachable from) v2.5
    $ git log test..master	# commits reachable from master but not test
    $ git log master..test	# commits reachable from test but not master
    $ git log master...test	# commits reachable from either test or
    			            #    master, but not both
    $ git log --since="2 weeks ago" # commits from the last 2 weeks
    $ git log Makefile      # commits that modify Makefile
    $ git log fs/		    # commits that modify any file under fs/
    $ git log -S'foo()'	    # commits that add or remove any file data
    			            # matching the string 'foo()'
    $ git log --no-merges	# dont show merge commits

And of course you can combine all of these; the following finds
commits since v2.5 which touch the Makefile or any file under fs:

    $ git log v2.5.. Makefile fs/

Git log will show a listing of each commit, with the most recent commits
first, that match the arguments given to the log command.

	commit f491239170cb1463c7c3cd970862d6de636ba787
	Author: Matt McCutchen <matt@mattmccutchen.net>
	Date:   Thu Aug 14 13:37:41 2008 -0400

	    git format-patch documentation: clarify what --cover-letter does
    
	commit 7950659dc9ef7f2b50b18010622299c508bfdfc3
	Author: Eric Raible <raible@gmail.com>
	Date:   Thu Aug 14 10:12:54 2008 -0700

	    bash completion: 'git apply' should use 'fix' not 'strip'
	    Bring completion up to date with the man page.
   
You can also ask git log to show patches:

    $ git log -p

	commit da9973c6f9600d90e64aac647f3ed22dfd692f70
	Author: Robert Schiele <rschiele@gmail.com>
	Date:   Mon Aug 18 16:17:04 2008 +0200

	    adapt git-cvsserver manpage to dash-free syntax

	diff --git a/Documentation/git-cvsserver.txt b/Documentation/git-cvsserver.txt
	index c2d3c90..785779e 100644
	--- a/Documentation/git-cvsserver.txt
	+++ b/Documentation/git-cvsserver.txt
	@@ -11,7 +11,7 @@ SYNOPSIS
	 SSH:

	 [verse]
	-export CVS_SERVER=git-cvsserver
	+export CVS_SERVER="git cvsserver"
	 'cvs' -d :ext:user@server/path/repo.git co <HEAD_name>

	 pserver (/etc/inetd.conf):

### Log Stats ###

If you pass the <code>--stat</code> option to 'git log', it will show you
which files have changed in that commit and how many lines were added and 
removed from each.

	$ git log --stat
	
	commit dba9194a49452b5f093b96872e19c91b50e526aa
	Author: Junio C Hamano <gitster@pobox.com>
	Date:   Sun Aug 17 15:44:11 2008 -0700

	    Start 1.6.0.X maintenance series
    
	 Documentation/RelNotes-1.6.0.1.txt |   15 +++++++++++++++
	 RelNotes                           |    2 +-
	 2 files changed, 16 insertions(+), 1 deletions(-)


### Formatting the Log ###

You can also format the log output almost however you want.  The '--pretty'
option can take a number of preset formats, such as 'oneline':

	$ git log --pretty=oneline
	a6b444f570558a5f31ab508dc2a24dc34773825f dammit, this is the second time this has reverted
	49d77f72783e4e9f12d1bbcacc45e7a15c800240 modified index to create refs/heads if it is not 
	9764edd90cf9a423c9698a2f1e814f16f0111238 Add diff-lcs dependency
	e1ba1e3ca83d53a2f16b39c453fad33380f8d1cc Add dependency for Open4
	0f87b4d9020fff756c18323106b3fd4e2f422135 merged recent changes: * accepts relative alt pat
	f0ce7d5979dfb0f415799d086e14a8d2f9653300 updated the Manifest file

or you can do 'short' format:

	$ git log --pretty=short
	commit a6b444f570558a5f31ab508dc2a24dc34773825f
	Author: Scott Chacon <schacon@gmail.com>

	    dammit, this is the second time this has reverted

	commit 49d77f72783e4e9f12d1bbcacc45e7a15c800240
	Author: Scott Chacon <schacon@gmail.com>

	    modified index to create refs/heads if it is not there

	commit 9764edd90cf9a423c9698a2f1e814f16f0111238
	Author: Hans Engel <engel@engel.uk.to>

	    Add diff-lcs dependency

You can also use 'medium', 'full', 'fuller', 'email' or 'raw'.  If those formats
aren't exactly what you need, you can also create your own format with the
'--pretty=format' option (see the linkgit:git-log[1] docs for all the formatting options).

	$ git log --pretty=format:'%h was %an, %ar, message: %s'
	a6b444f was Scott Chacon, 5 days ago, message: dammit, this is the second time this has re
	49d77f7 was Scott Chacon, 8 days ago, message: modified index to create refs/heads if it i
	9764edd was Hans Engel, 11 days ago, message: Add diff-lcs dependency
	e1ba1e3 was Hans Engel, 11 days ago, message: Add dependency for Open4
	0f87b4d was Scott Chacon, 12 days ago, message: merged recent changes:
	
Another interesting thing you can do is visualize the commit graph with the
'--graph' option, like so:

	$ git log --pretty=format:'%h : %s' --graph
	* 2d3acf9 : ignore errors from SIGCHLD on trap
	*   5e3ee11 : Merge branch 'master' of git://github.com/dustin/grit
	|\  
	| * 420eac9 : Added a method for getting the current branch.
	* | 30e367c : timeout code and tests
	* | 5a09431 : add timeout protection to grit
	* | e1193f8 : support for heads with slashes in them
	|/  
	* d6016bc : require time for xmlschema

It will give a pretty nice ASCII representation of the commit history lines.


### Ordering the Log ###

You can also view the log entries in a few different orders. 
Note that git log starts with the most recent commit and works
backwards through the parents; however, since git history can contain
multiple independent lines of development, the particular order that
commits are listed in may be somewhat arbitrary.

If you want to specify a certain order, you can add an ordering option
to the git log command.

By default, the commits are shown in reverse chronological order.

However, you can also specify '--topo-order', which makes the commits
appear in topological order (i.e. descendant commits are shown before their parents).
If we view the git log for the Grit repo in topo-order, you can see that the
development lines are all grouped together.

	$ git log --pretty=format:'%h : %s' --topo-order --graph
	*   4a904d7 : Merge branch 'idx2'
	|\  
	| *   dfeffce : merged in bryces changes and fixed some testing issues
	| |\  
	| | * 23f4ecf : Clarify how to get a full count out of Repo#commits
	| | *   9d6d250 : Appropriate time-zone test fix from halorgium
	| | |\  
	| | | * cec36f7 : Fix the to_hash test to run in US/Pacific time
	| | * | decfe7b : fixed manifest and grit.rb to make correct gemspec
	| | * | cd27d57 : added lib/grit/commit_stats.rb to the big list o' files
	| | * | 823a9d9 : cleared out errors by adding in Grit::Git#run method
	| | * |   4eb3bf0 : resolved merge conflicts, hopefully amicably
	| | |\ \  
	| | | * | d065e76 : empty commit to push project to runcoderun
	| | | * | 3fa3284 : whitespace
	| | | * | d01cffd : whitespace
	| | | * | 7c74272 : oops, update version here too
	| | | * | 13f8cc3 : push 0.8.3
	| | | * | 06bae5a : capture stderr and log it if debug is true when running commands
	| | | * | 0b5bedf : update history
	| | | * | d40e1f0 : some docs
	| | | * | ef8a23c : update gemspec to include the newly added files to manifest
	| | | * | 15dd347 : add missing files to manifest; add grit test
	| | | * | 3dabb6a : allow sending debug messages to a user defined logger if provided; tes
	| | | * | eac1c37 : pull out the date in this assertion and compare as xmlschemaw, to avoi
	| | | * | 0a7d387 : Removed debug print.
	| | | * | 4d6b69c : Fixed to close opened file description.

You can also use '--date-order', which orders the commits primarily by commit date.
This option is similar to --topo-order in the sense that no parent comes before all of its children, 
but otherwise things are still ordered in the commit timestamp order. You can
see that development lines are not grouped together here, that they jump around
as parallel development occurred:

	$ git log --pretty=format:'%h : %s' --date-order --graph
	*   4a904d7 : Merge branch 'idx2'
	|\  
	* | 81a3e0d : updated packfile code to recognize index v2
	| *   dfeffce : merged in bryces changes and fixed some testing issues
	| |\  
	| * | c615d80 : fixed a log issue
	|/ /  
	| * 23f4ecf : Clarify how to get a full count out of Repo#commits
	| *   9d6d250 : Appropriate time-zone test fix from halorgium
	| |\  
	| * | decfe7b : fixed manifest and grit.rb to make correct gemspec
	| * | cd27d57 : added lib/grit/commit_stats.rb to the big list o' file
	| * | 823a9d9 : cleared out errors by adding in Grit::Git#run method
	| * |   4eb3bf0 : resolved merge conflicts, hopefully amicably
	| |\ \  
	| * | | ba23640 : Fix CommitDb errors in test (was this the right fix?
	| * | | 4d8873e : test_commit no longer fails if you're not in PDT
	| * | | b3285ad : Use the appropriate method to find a first occurrenc
	| * | | 44dda6c : more cleanly accept separate options for initializin
	| * | | 839ba9f : needed to be able to ask Repo.new to work with a bar
	| | * | d065e76 : empty commit to push project to runcoderun
	* | | | 791ec6b : updated grit gemspec
	* | | | 756a947 : including code from github updates
	| | * | 3fa3284 : whitespace
	| | * | d01cffd : whitespace
	| * | | a0e4a3d : updated grit gemspec
	| * | | 7569d0d : including code from github updates


Lastly, you can reverse the order of the log with the '--reverse' option.


[gitcast:c4-git-log]("GitCast #4: Git Log")
