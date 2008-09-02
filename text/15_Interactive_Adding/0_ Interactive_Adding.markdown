## Interactive Adding ##

Interactive Adding is a really nice way of working with and visualizing
the Git index.  To start it up, simply type 'git add -i'.  Git will show
you all the modified files you have and their status.

	$>git add -i
	           staged     unstaged path
	  1:    unchanged        +4/-0 assets/stylesheets/style.css
	  2:    unchanged      +23/-11 layout/book_index_template.html
	  3:    unchanged        +7/-7 layout/chapter_template.html
	  4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown

	*** Commands ***
	  1: status	  2: update	  3: revert	  4: add untracked
	  5: patch	  6: diff	  7: quit	  8: help
	What now> 

In this case, we can see that there are 5 modified files that have not been
added to our index yet (unstaged), and even how many lines have been added to
or removed from each.  It then shows us an interactive menu of what we can
do in this mode.

If we want to stage the files, we can type '2' or 'u' for the update mode. 
Then I can specify which files I want to stage (add to the index) by typing
in the numbers of the files (in this case, 1-4)

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +4/-0 assets/stylesheets/style.css
	  2:    unchanged      +23/-11 layout/book_index_template.html
	  3:    unchanged        +7/-7 layout/chapter_template.html
	  4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	Update>> 1-4
	           staged     unstaged path
	* 1:    unchanged        +4/-0 assets/stylesheets/style.css
	* 2:    unchanged      +23/-11 layout/book_index_template.html
	* 3:    unchanged        +7/-7 layout/chapter_template.html
	* 4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	Update>> 

If I hit enter, I will be taken back to the main menu where I can see that
the file status has changed:

	What now> status
	           staged     unstaged path
	  1:        +4/-0      nothing assets/stylesheets/style.css
	  2:      +23/-11      nothing layout/book_index_template.html
	  3:        +7/-7      nothing layout/chapter_template.html
	  4:        +3/-3      nothing script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown

Now we can see the first four files are staged and the last one is still not.
This is basically a compressed way to see the same information we see when
we run 'git status' from the command line:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   assets/stylesheets/style.css
	#	modified:   layout/book_index_template.html
	#	modified:   layout/chapter_template.html
	#	modified:   script/pdf.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	#

There are a number of useful things we can do, including unstaging files (3: revert),
adding untracked files (4: add untracked), and viewing diffs (6: diff). Those
are all pretty straightforward.  However, there is one command that is pretty
cool here, which is staging patches (5: patch).

If you type '5' or 'p' in the menu, git will show you your diff patch by patch 
(or hunk by hunk) and ask if you want to stage each one.  That way you can 
actually stage for a commit a part of a file edit.  If you've edited a file
and want to only commit part of it and not an unfinished part, or commit 
documentation or whitespace changes seperate from substantive changes, you can
use 'git add -i' to do so relatively easily.

Here I've staged some changes to the book_index_template.html file, but not all
of them:

	         staged     unstaged path
	1:        +4/-0      nothing assets/stylesheets/style.css
	2:       +20/-7        +3/-4 layout/book_index_template.html
	3:        +7/-7      nothing layout/chapter_template.html
	4:        +3/-3      nothing script/pdf.rb
	5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	6:    unchanged       +85/-0 text/15_Interactive_Adding/0_ Interactive_Adding.markdown

When you are done making changes to your index through 'git add -i', you simply
quit (7: quit) and then run 'git commit' to commit the staged changes.  Remember
**not** to run 'git commit -a', which will blow away all the careful changes 
you've just made and simply commit everything.

[gitcast:c3_add_interactive]("GitCast #3: Interactive Adding")
