## The Git Object Model ##

### The SHA ###

All the information needed to represent the history of a
project is stored in files referenced by a 40-digit "object name" that 
looks something like this:
    
    6ff87c4664981e4397625791c8ea3bbb5f2279a3
    
You will see these 40-character strings all over the place in Git.
In each case the name is calculated by taking the SHA1 hash of the
contents of the object.  The SHA1 hash is a cryptographic hash function.
What that means to us is that it is virtually impossible to find two different
objects with the same name.  This has a number of advantages; among
others:

- Git can quickly determine whether two objects are identical or not,
  just by comparing names.
- Since object names are computed the same way in every repository, the
  same content stored in two repositories will always be stored under
  the same name.
- Git can detect errors when it reads an object, by checking that the
  object's name is still the SHA1 hash of its contents.

### The Objects ###

Every object consists of three things - a **type**, a **size** and **content**.
The _size_ is simply the size of the contents, the contents depend on what
type of object it is, and there are four different types of objects: 
"blob", "tree", "commit", and "tag".

- A **"blob"** is used to store file data - it is generally a file.
- A **"tree"** is basically like a directory - it references a bunch of
    other trees and/or blobs (i.e. files and sub-directories)
- A **"commit"** points to a single tree, marking it as what the project
    looked like at a certain point in time.  It contains meta-information
    about that point in time, such as a timestamp, the author of the changes
    since the last commit, a pointer to the previous commit(s), etc.
- A **"tag"** is a way to mark a specific commit as special in some way.  It
    is normally used to tag certain commits as specific releases or something
    along those lines.

Almost all of Git is built around manipulating this simple structure of four
different object types.  It is sort of its own little filesystem that sits
on top of your machine's filesystem.

### Different from SVN ###

It is important to note that this is very different from most SCM systems
that you may be familiar with.  Subversion, CVS, Perforce, Mercurial and the
like all use _Delta Storage_ systems - they store the differences between one
commit and the next.  Git does not do this - it stores a snapshot of what all
the files in your project look like in this tree structure each time you
commit. This is a very important concept to understand when using Git.
