## Comparing Commits - Git Diff ##

You can generate diffs between any two versions of your project using
linkgit:git-diff[1]:

    $ git diff master..test

That will produce the diff between the tips of the two branches.  If
you'd prefer to find the diff from their common ancestor to test, you
can use three dots instead of two:

    $ git diff master...test

linkgit:git-diff[1] is an incredibly useful tool for figuring out what has
changed between any two points in your project's history, or to see what
people are trying to introduce in new branches, etc.

### What you will commit ###

You will commonly use linkgit:git-diff[1] for figuring out differences between 
your last commit, your index, and your current working directory.
A common use is to simply run 
    
    $ git diff
    
which will show you changes in the working directory that are not yet 
staged for the next commit. 
If you want to see what _is_ staged for the next commit, you can run

    $ git diff --cached

which will show you the difference between the index and your last commit; 
what you would be committing if you run "git commit" without the "-a" option.
Lastly, you can run 

    $ git diff HEAD

which shows changes in the working directory since your last commit; 
what you would be committing if you run "git commit -a".

### More Diff Options ###

If you want to see how your current working directory differs from the state of
the project in another branch, you can run something like

    $ git diff test
    
This will show you what is different between your current working directory
and the snapshot on the 'test' branch.  You can also limit the comparison to a
specific file or subdirectory by adding a *path limiter*:

    $ git diff HEAD -- ./lib 

That command will show the changes between your current working directory and
the last commit (or, more accurately, the tip of the current branch), limiting
the comparison to files in the 'lib' subdirectory.

If you don't want to see the whole patch, you can add the '--stat' option,
which will limit the output to the files that have changed along with a little
text graph depicting how many lines changed in each file.

    $>git diff --stat
     layout/book_index_template.html                    |    8 ++-
     text/05_Installing_Git/0_Source.markdown           |   14 ++++++
     text/05_Installing_Git/1_Linux.markdown            |   17 +++++++
     text/05_Installing_Git/2_Mac_104.markdown          |   11 +++++
     text/05_Installing_Git/3_Mac_105.markdown          |    8 ++++
     text/05_Installing_Git/4_Windows.markdown          |    7 +++
     .../1_Getting_a_Git_Repo.markdown                  |    7 +++-
     .../0_ Comparing_Commits_Git_Diff.markdown         |   45 +++++++++++++++++++-
     .../0_ Hosting_Git_gitweb_repoorcz_github.markdown |    4 +-
     9 files changed, 115 insertions(+), 6 deletions(-)

Sometimes that makes it easier to see overall what has changed, to jog your memory.
