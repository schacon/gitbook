## Finding Issues - Git Bisect ##

Suppose version 2.6.18 of your project worked, but the version at
"master" crashes.  Sometimes the best way to find the cause of such a
regression is to perform a brute-force search through the project's
history to find the particular commit that caused the problem.  The
linkgit:git-bisect[1] command can help you do this:

    $ git bisect start
    $ git bisect good v2.6.18
    $ git bisect bad master
    Bisecting: 3537 revisions left to test after this
    [65934a9a028b88e83e2b0f8b36618fe503349f8e] BLOCK: Make USB storage depend on SCSI rather than selecting it [try #6]

If you run "git branch" at this point, you'll see that git has
temporarily moved you to a new branch named "bisect".  This branch
points to a commit (with commit id 65934...) that is reachable from
"master" but not from v2.6.18.  Compile and test it, and see whether
it crashes.  Assume it does crash.  Then:

    $ git bisect bad
    Bisecting: 1769 revisions left to test after this
    [7eff82c8b1511017ae605f0c99ac275a7e21b867] i2c-core: Drop useless bitmaskings

checks out an older version.  Continue like this, telling git at each
stage whether the version it gives you is good or bad, and notice
that the number of revisions left to test is cut approximately in
half each time.

After about 13 tests (in this case), it will output the commit id of
the guilty commit.  You can then examine the commit with
linkgit:git-show[1], find out who wrote it, and mail them your bug
report with the commit id.  Finally, run

    $ git bisect reset

to return you to the branch you were on before and delete the
temporary "bisect" branch.

Note that the version which git-bisect checks out for you at each
point is just a suggestion, and you're free to try a different
version if you think it would be a good idea.  For example,
occasionally you may land on a commit that broke something unrelated;
run

    $ git bisect visualize

which will run gitk and label the commit it chose with a marker that
says "bisect".  Choose a safe-looking commit nearby, note its commit
id, and check it out with:

    $ git reset --hard fb47ddb2db...

then test, run "bisect good" or "bisect bad" as appropriate, and
continue.