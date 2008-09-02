## Finding with Git Grep ##

Finding files with words or phrases in Git is really easy with the 
linkgit:git-grep[1] command.  It is possible to do this with the normal
unix 'grep' command, but with 'git grep' you can also search through
previous versions of the project without having to check them out.

For example, if I wanted to see every place that used the 'xmmap' call in
my git.git repository, I could run this:

	$ git grep xmmap
	config.c:               contents = xmmap(NULL, contents_sz, PROT_READ,
	diff.c:         s->data = xmmap(NULL, s->size, PROT_READ, MAP_PRIVATE, fd, 0);
	git-compat-util.h:extern void *xmmap(void *start, size_t length, int prot, int fla
	read-cache.c:   mmap = xmmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_PRIVATE,
	refs.c: log_mapped = xmmap(NULL, mapsz, PROT_READ, MAP_PRIVATE, logfd, 0);
	sha1_file.c:    map = xmmap(NULL, mapsz, PROT_READ, MAP_PRIVATE, fd, 0);
	sha1_file.c:    idx_map = xmmap(NULL, idx_size, PROT_READ, MAP_PRIVATE, fd, 0);
	sha1_file.c:                    win->base = xmmap(NULL, win->len,
	sha1_file.c:                    map = xmmap(NULL, *size, PROT_READ, MAP_PRIVATE, f
	sha1_file.c:            buf = xmmap(NULL, size, PROT_READ, MAP_PRIVATE, fd, 0);
	wrapper.c:void *xmmap(void *start, size_t length,

If I wanted to see the line number of each match as well, I can add the '-n'
option:

	$>git grep -n xmmap
	config.c:1016:          contents = xmmap(NULL, contents_sz, PROT_READ,
	diff.c:1833:            s->data = xmmap(NULL, s->size, PROT_READ, MAP_PRIVATE, fd,
	git-compat-util.h:291:extern void *xmmap(void *start, size_t length, int prot, int
	read-cache.c:1178:      mmap = xmmap(NULL, mmap_size, PROT_READ | PROT_WRITE, MAP_
	refs.c:1345:    log_mapped = xmmap(NULL, mapsz, PROT_READ, MAP_PRIVATE, logfd, 0);
	sha1_file.c:377:        map = xmmap(NULL, mapsz, PROT_READ, MAP_PRIVATE, fd, 0);
	sha1_file.c:479:        idx_map = xmmap(NULL, idx_size, PROT_READ, MAP_PRIVATE, fd
	sha1_file.c:780:                        win->base = xmmap(NULL, win->len,
	sha1_file.c:1076:                       map = xmmap(NULL, *size, PROT_READ, MAP_PR
	sha1_file.c:2393:               buf = xmmap(NULL, size, PROT_READ, MAP_PRIVATE, fd
	wrapper.c:89:void *xmmap(void *start, size_t length,

If we're only interested in the filename, we can pass the '--name-only' option:

	$>git grep --name-only xmmap
	config.c
	diff.c
	git-compat-util.h
	read-cache.c
	refs.c
	sha1_file.c
	wrapper.c

We could also see how many line matches we have in each file with the '-c' 
option:

	$>git grep -c xmmap
	config.c:1
	diff.c:1
	git-compat-util.h:1
	read-cache.c:1
	refs.c:1
	sha1_file.c:5
	wrapper.c:1

Now, if I wanted to see where that was used in a specific version of git, I 
could add the tag reference to the end, like this:

	$ git grep xmmap v1.5.0
	v1.5.0:config.c:                contents = xmmap(NULL, st.st_size, PROT_READ,
	v1.5.0:diff.c:          s->data = xmmap(NULL, s->size, PROT_READ, MAP_PRIVATE, fd,
	v1.5.0:git-compat-util.h:static inline void *xmmap(void *start, size_t length,
	v1.5.0:read-cache.c:                    cache_mmap = xmmap(NULL, cache_mmap_size, 
	v1.5.0:refs.c:  log_mapped = xmmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, logfd
	v1.5.0:sha1_file.c:     map = xmmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 
	v1.5.0:sha1_file.c:     idx_map = xmmap(NULL, idx_size, PROT_READ, MAP_PRIVATE, fd
	v1.5.0:sha1_file.c:                     win->base = xmmap(NULL, win->len,
	v1.5.0:sha1_file.c:     map = xmmap(NULL, st.st_size, PROT_READ, MAP_PRIVATE, fd, 
	v1.5.0:sha1_file.c:             buf = xmmap(NULL, size, PROT_READ, MAP_PRIVATE, fd

We can see that there are some differences between the current lines and these
lines in version 1.5.0, one of which is that xmmap is now used in wrapper.c where
it was not back in v1.5.0.

We can also combine search terms in grep.  Say we wanted to search for where
SORT_DIRENT is defined in our repository:

	$ git grep -e '#define' --and -e SORT_DIRENT
	builtin-fsck.c:#define SORT_DIRENT 0
	builtin-fsck.c:#define SORT_DIRENT 1

We can also search for every file that has *both* search terms, but display
each line that has *either* of the terms in those files:

	$ git grep --all-match -e '#define' -e SORT_DIRENT
	builtin-fsck.c:#define REACHABLE 0x0001
	builtin-fsck.c:#define SEEN      0x0002
	builtin-fsck.c:#define ERROR_OBJECT 01
	builtin-fsck.c:#define ERROR_REACHABLE 02
	builtin-fsck.c:#define SORT_DIRENT 0
	builtin-fsck.c:#define DIRENT_SORT_HINT(de) 0
	builtin-fsck.c:#define SORT_DIRENT 1
	builtin-fsck.c:#define DIRENT_SORT_HINT(de) ((de)->d_ino)
	builtin-fsck.c:#define MAX_SHA1_ENTRIES (1024)
	builtin-fsck.c: if (SORT_DIRENT)

We can also search for lines that have one term and either of two other terms,
for example, if we wanted to see where we defined constants that had either
PATH or MAX in the name:

	$ git grep -e '#define' --and \( -e PATH -e MAX \) 
	abspath.c:#define MAXDEPTH 5
	builtin-blame.c:#define MORE_THAN_ONE_PATH      (1u<<13)
	builtin-blame.c:#define MAXSG 16
	builtin-describe.c:#define MAX_TAGS     (FLAG_BITS - 1)
	builtin-fetch-pack.c:#define MAX_IN_VAIN 256
	builtin-fsck.c:#define MAX_SHA1_ENTRIES (1024)
	...
	

	