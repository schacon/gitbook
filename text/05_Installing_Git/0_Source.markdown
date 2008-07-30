### Installing from Source ###

In short, on a Unix-based system, you can download the Git source code from the
[Git Download Page](http://git-scm.com/download), and then run something
along the lines of :

    $ make prefix=/usr all ;# as yourself
    $ make prefix=/usr install ;# as root

You will need the [expat](http://expat.sourceforge.net/), 
[curl](http://curl.linux-mirror.org),
[zlib](http://www.zlib.net), and [openssl](http://www.openssl.org) libraries
installed - though with the possible exception of *expat*, these will normally already
be there.