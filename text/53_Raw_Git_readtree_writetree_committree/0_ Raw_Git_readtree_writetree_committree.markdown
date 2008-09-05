## Raw Git ##

Here we will take a look at how to manipulate git at a more raw level, in
case you would like to write a tool that generates new blobs, trees or commits 
in a more artificial way.  If you want to write a script that uses more low-level
git plumbing to do something new, here are some of the tools you'll need.

### Creating Blobs ###

Creating a blob in your Git repository and getting a SHA back is pretty easy.
The linkgit:git-hash-object[1] command is all you'll need.  To create a blob
object from an existing file, just run it with the '-w' option (which tells it
to write the blob, not just compute the SHA).

	$ git hash-object -w myfile.txt
	6ff87c4664981e4397625791c8ea3bbb5f2279a3

	$ git hash-object -w myfile2.txt
	3bb0e8592a41ae3185ee32266c860714980dbed7

The STDOUT output of the command will the the SHA of the blob that was created.

### Creating Trees ###

Now lets say you want to create a tree from your new objects. 
The linkgit:git-mktree[1] command makes it pretty simple to generate new
tree objects from linkgit:git-ls-tree[1] formatted output.  For example, if
you write the following to a file named '/tmp/tree.txt' :

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	file1
	100644 blob 3bb0e8592a41ae3185ee32266c860714980dbed7	file2

and then piped that through the linkgit:git-mktree[1] command, Git will
write a new tree to the object database and give you back the new sha of that
tree.

	$ cat /tmp/tree.txt | git mk-tree
	f66a66ab6a7bfe86d52a66516ace212efa00fe1f

Then, we can take that and make it a subdirectory of yet another tree, and so 
on.  If we wanted to create a new tree with that one as a subtree, we just 
create a new file (/tmp/newtree.txt) with our new SHA as a tree in it:

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	file1-copy
	040000 tree f66a66ab6a7bfe86d52a66516ace212efa00fe1f	our_files

and then use linkgit:git-mk-tree[1] again:

	$ cat /tmp/newtree.txt | git mk-tree
	5bac6559179bd543a024d6d187692343e2d8ae83

And we now have an artificial directory structure in Git that looks like this:

	.
	|-- file1-copy
	`-- our_files
	    |-- file1
	    `-- file2

	1 directory, 3 files
	
without that structure ever having actually existed on disk.  Plus, we have
a SHA (<code>5bac6559</code>) that points to it.

### Rearranging Trees ###

We can also do tree manipulation by combining trees into new structures using
the index file.  As a simple example, let's take the tree we just created and
make a new tree that has two copies of our <code>5bac6559</code> tree in it
using a temporary index file. (You can do this by resetting the GIT_INDEX_FILE
environment variable or on the command line)

First, we read the tree into our index file under a new prefix using the
linkgit:git-read-tree[1] command, and then write the index contents as 
a tree using the linkgit:git-write-tree[1] command:

	$ export GIT_INDEX_FILE=/tmp/index
	$ git read-tree --prefix=copy1/  5bac6559
	$ git read-tree --prefix=copy2/  5bac6559
	$ git write-tree 
	bb2fa6de7625322322382215d9ea78cfe76508c1
	
	$>git ls-tree bb2fa
	040000 tree 5bac6559179bd543a024d6d187692343e2d8ae83	copy1
	040000 tree 5bac6559179bd543a024d6d187692343e2d8ae83	copy2
	
So now we can see that we've created a new tree just from index manipulation.
You can also do interesting merge operations and such in a temporary index
this way - see the linkgit:git-read-tree[1] docs for more information.

### Creating Commits ###

Now that we have a tree SHA, we can create a commit object that points to it.
We can do this using the linkgit:git-commit-tree[1] command.  Most of the data
that goes into the commit has to be set as environment variables, so you'll want
to set the following:

	GIT_AUTHOR_NAME
	GIT_AUTHOR_EMAIL
	GIT_AUTHOR_DATE
	GIT_COMMITTER_NAME
	GIT_COMMITTER_EMAIL
	GIT_COMMITTER_DATE

Then you will need to write your commit message to a file or somehow pipe it
into the command through STDIN. Then, you can create your commit object 
based on the tree sha we have.

	$ git commit-tree bb2fa < /tmp/message
	a5f85ba5875917319471dfd98dfc636c1dc65650
	
If you want to specify one or more parent commits, simply add the shas on the
command line with a '-p' option before each.  The SHA of the new commit object
will be returned via STDOUT.

### Updating a Branch Ref ###

Now that we have a new commit object SHA, we can update a branch to point to
it if we want to.  Lets say we want to update our 'master' branch to point to
the new commit we just created - we would use the linkgit:git-update-ref[1]
command:

	$ git update-ref refs/heads/master a5f85ba5875917319471dfd98dfc636c1dc65650

