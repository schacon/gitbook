## Git and Email ##

### Submitting patches to a project ###

If you just have a few changes, the simplest way to submit them may
just be to send them as patches in email:

First, use linkgit:git-format-patch[1]; for example:

    $ git format-patch origin

will produce a numbered series of files in the current directory, one
for each patch in the current branch but not in origin/HEAD.

You can then import these into your mail client and send them by
hand.  However, if you have a lot to send at once, you may prefer to
use the linkgit:git-send-email[1] script to automate the process.
Consult the mailing list for your project first to determine how they
prefer such patches be handled.


### Importing patches to a project ###

Git also provides a tool called linkgit:git-am[1] (am stands for
"apply mailbox"), for importing such an emailed series of patches.
Just save all of the patch-containing messages, in order, into a
single mailbox file, say "patches.mbox", then run

    $ git am -3 patches.mbox

Git will apply each patch in order; if any conflicts are found, it
will stop, and you can manually fix the conflicts and
resolve the merge.  (The "-3" option tells
git to perform a merge; if you would prefer it just to abort and
leave your tree and index untouched, you may omit that option.)

Once the index is updated with the results of the conflict
resolution, instead of creating a new commit, just run

    $ git am --resolved

and git will create the commit for you and continue applying the
remaining patches from the mailbox.

The final result will be a series of commits, one for each patch in
the original mailbox, with authorship and commit log message each
taken from the message containing each patch.
