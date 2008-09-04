## Customizing Git ##

linkgit:git-config[1]

### Changing your Editor ###

	$ git config --global core.editor emacs

### Adding Aliases ###
	
	$ git config --global alias.last 'cat-file commit HEAD'
	
	$ git last
	tree c85fbd1996b8e7e5eda1288b56042c0cdb91836b
	parent cdc9a0a28173b6ba4aca00eb34f5aabb39980735
	author Scott Chacon <schacon@gmail.com> 1220473867 -0700
	committer Scott Chacon <schacon@gmail.com> 1220473867 -0700

	fixed a weird formatting problem
	
	$ git cat-file commit HEAD
	tree c85fbd1996b8e7e5eda1288b56042c0cdb91836b
	parent cdc9a0a28173b6ba4aca00eb34f5aabb39980735
	author Scott Chacon <schacon@gmail.com> 1220473867 -0700
	committer Scott Chacon <schacon@gmail.com> 1220473867 -0700

	fixed a weird formatting problem

### Adding Color ###

See all color.* options in the linkgit:git-config[1] docs

	$ git config color.branch auto
	$ git config color.diff auto
	$ git config color.interactive auto
	$ git config color.status auto

Or, you can set all of them on with the color.ui option:

	$ git config color.ui true
	
### Commit Template ###

	$ git config commit.template '/etc/git-commit-template'
	
### Log Format ###

	$ git config format.pretty oneline


### Other Config Options ###

There are also a number of interesting options for packing, gc-ing, merging,
remotes, branches, http transport, diffs, paging, whitespace and more.  If you
want to tweak these, check out the linkgit:git-config[1] docs.