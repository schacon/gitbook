### Multiway Merge ###

You can merge several heads at one time by simply listing them on the same 
linkgit:git-merge[1] command.  For instance,

	$ git merge scott/master rick/master tom/master
	
is the equivalent of:

	$ git merge scott/master
	$ git merge rick/master
	$ git merge tom/master

### Subtree ###

There are situations where you want to include contents in your project from 
an independently developed project. You can just pull from the other project 
as long as there are no conflicting paths.

The problematic case is when there are conflicting files. Potential 
candidates are Makefiles and other standard filenames. You could merge 
these files but probably you do not want to. A better solution for this 
problem can be to merge the project as its own subdirectory. This is not 
supported by the recursive merge strategy, so just pulling won't work.

What you want is the subtree merge strategy, which helps you in such a situation.

In this example, let's say you have the repository at /path/to/B 
(but it can be an URL as well, if you want). You want to merge the master 
branch of that repository to the dir-B subdirectory in your current branch.

Here is the command sequence you need:

	$ git remote add -f Bproject /path/to/B (1)
	$ git merge -s ours --no-commit Bproject/master (2)
	$ git read-tree --prefix=dir-B/ -u Bproject/master (3)
	$ git commit -m "Merge B project as our subdirectory" (4)
	$ git pull -s subtree Bproject master (5)
	

The benefit of using subtree merge is that it requires less administrative 
burden from the users of your repository. It works with older 
(before Git v1.5.2) clients and you have the code right after clone.

However if you use submodules then you can choose not to transfer the 
submodule objects. This may be a problem with the subtree merge.

Also, in case you make changes to the other project, it is easier to 
submit changes if you just use submodules.

(from [Using Subtree Merge](http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html))


