## Git References ##

Branches, remote-tracking branches, and tags are all references to
commits.  All references are named with a slash-separated path name
starting with "refs"; the names we've been using so far are actually
shorthand:

	- The branch "test" is short for "refs/heads/test".
	- The tag "v2.6.18" is short for "refs/tags/v2.6.18".
	- "origin/master" is short for "refs/remotes/origin/master".

The full name is occasionally useful if, for example, there ever
exists a tag and a branch with the same name.

(Newly created refs are actually stored in the .git/refs directory,
under the path given by their name.  However, for efficiency reasons
they may also be packed together in a single file; see
linkgit:git-pack-refs[1]).

As another useful shortcut, the "HEAD" of a repository can be referred
to just using the name of that repository.  So, for example, "origin"
is usually a shortcut for the HEAD branch in the repository "origin".

For the complete list of paths which git checks for references, and
the order it uses to decide which to choose when there are multiple
references with the same shorthand name, see the "SPECIFYING
REVISIONS" section of linkgit:git-rev-parse[1].


### Showing commits unique to a given branch ###

Suppose you would like to see all the commits reachable from the branch
head named "master" but not from any other head in your repository.

We can list all the heads in this repository with
linkgit:git-show-ref[1]:

    $ git show-ref --heads
    bf62196b5e363d73353a9dcf094c59595f3153b7 refs/heads/core-tutorial
    db768d5504c1bb46f63ee9d6e1772bd047e05bf9 refs/heads/maint
    a07157ac624b2524a059a3414e99f6f44bebc1e7 refs/heads/master
    24dbc180ea14dc1aebe09f14c8ecf32010690627 refs/heads/tutorial-2
    1e87486ae06626c2f31eaa63d26fc0fd646c8af2 refs/heads/tutorial-fixes

We can get just the branch-head names, and remove "master", with
the help of the standard utilities cut and grep:

    $ git show-ref --heads | cut -d' ' -f2 | grep -v '^refs/heads/master'
    refs/heads/core-tutorial
    refs/heads/maint
    refs/heads/tutorial-2
    refs/heads/tutorial-fixes

And then we can ask to see all the commits reachable from master
but not from these other heads:

    $ gitk master --not $( git show-ref --heads | cut -d' ' -f2 |
    				grep -v '^refs/heads/master' )

Obviously, endless variations are possible; for example, to see all
commits reachable from some head but not from any tag in the repository:

    $ gitk $( git show-ref --heads ) --not  $( git show-ref --tags )

(See linkgit:git-rev-parse[1] for explanations of commit-selecting
syntax such as `--not`.)

(!!update-ref!!)
