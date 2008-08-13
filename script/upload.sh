# this script moves the generated book files to my server
#scp -r output/book/* git-scm.com:/var/www/
rsync -e ssh -av output/book/* git-scm.com:/var/www
