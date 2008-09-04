## Git Hooks ##

[Git Hooks](http://www.kernel.org/pub/software/scm/git/docs/githooks.html)

### Server Side Hooks ###

#### Post Receive ####


	GIT_DIR/hooks/post-receive

If you wrote it in Ruby, you might get the args this way:

	ruby
	rev_old, rev_new, ref = STDIN.read.split(" ")

Or in a bash script, something like this would work:
	
	#!/bin/sh
	# <oldrev> <newrev> <refname>
	# update a blame tree
	while read oldrev newrev ref
	do
		echo "STARTING [$oldrev $newrev $ref]"
		for path in `git diff-tree -r $oldrev..$newrev | awk '{print $6}'`
		do
		  echo "git update-ref refs/blametree/$ref/$path $newrev"
		  `git update-ref refs/blametree/$ref/$path $newrev`
		done
	done
	

### Client Side Hooks ###


#### Pre Commit ####

Running your tests automatically before you commit

 	GIT_DIR/hooks/pre-commit

Here is an example of a Ruby script that runs RSpec tests before allowing a commit.

	ruby  
	html_path = "spec_results.html"  
	`spec -f h:#{html_path} -f p spec` # run the spec. send progress to screen. save html results to html_path  

	# find out how many errors were found  
	html = open(html_path).read  
	examples = html.match(/(\d+) examples/)[0].to_i rescue 0  
	failures = html.match(/(\d+) failures/)[0].to_i rescue 0  
	pending = html.match(/(\d+) pending/)[0].to_i rescue 0  

	if failures.zero?  
	  puts "0 failures! #{examples} run, #{pending} pending"  
	else  
	  puts "\aDID NOT COMMIT YOUR FILES!"  
	  puts "View spec results at #{File.expand_path(html_path)}"  
	  puts  
	  puts "#{failures} failures! #{examples} run, #{pending} pending"  
	  exit 1  
	end

* http://probablycorey.wordpress.com/2008/03/07/git-hooks-make-me-giddy/