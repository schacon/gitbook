## Creating New Empty Branches ##

Ocasionally, you may want to keep branches in your repository that do not
share an ancestor with your normal code.  Some examples of this might be
generated documentation or something along those lines.  If you want to 
create a new branch head that does not use your current codebase as a 
parent, you can create an empty branch like this:

    git symbolic-ref HEAD refs/heads/newbranch 
    rm .git/index 
    git clean -fdx 
    <do work> 
    git add your files 
    git commit -m 'Initial commit'
    
[gitcast:c9-empty-branch]("GitCast #7: Creating Empty Branches")
