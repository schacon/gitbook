## Git Tag ##

### Lightweight Tags ###

We can create a tag to refer to a particular commit by running linkgit:git-tag[1]
with no arguments.

    $ git tag stable-1 1b2e1d63ff
    
After that, we can use stable-1 to refer to the commit 1b2e1d63ff.

This creates a "lightweight" tag, basically a branch that never moves.
If you would also like to include a comment with the tag,
and possibly sign it cryptographically, then we can create a *tag object* instead.

### Tag Objects ###

If one of **-a**, **-s**, or **-u <key-id>** is passed, the command creates a tag object, 
and requires the tag message. Unless -m <msg> or -F <file> is given, an editor 
is started for the user to type in the tag message.

When this happens, a new object is added to the Git object database and the 
tag ref points to that _tag object_, rather than the commit itself. The strength
of this is that you can sign the tag, so you can verify that it is the correct
commit later.  You can create a tag object like this:

    $ git tag -a stable-1 1b2e1d63ff
    
It is actually possible to tag any object, but tagging commit objects is the 
most common. (In the Linux kernel source, the first tag object
references a tree, rather than a commit)

### Signed Tags ###

If you have a GPG key setup, you can create signed tags fairly easily.  First,
you will probably want to setup your key id in your _.git/config_ or _~.gitconfig_
file.

    [user]
        signingkey = <gpg-key-id>
        
You can also set that with

    $ git config (--global) user.signingkey <gpg-key-id>
    
Now you can create a signed tag simply by replacing the **-a** with a **-s**.

    $ git tag -s stable-1 1b2e1d63ff
    
If you don't have your GPG key in your config file, you can accomplish the same
thing this way:
    
    $ git tag -u <gpg-key-id> stable-1 1b2e1d63ff