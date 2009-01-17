## How Git Stores Objects ##

This chapter goes into detail about how Git physically stores objects.

All objects are stored as compressed contents by their sha values.  They
contain the object type, size and contents in a gzipped format.

There are two formats that Git keeps objects in - loose objects and 
packed objects. 

### Loose Objects ###

Loose objects are the simpler format.  It is simply the compressed data stored
in a single file on disk.  Every object written to a seperate file.

If the sha of your object is <code>ab04d884140f7b0cf8bbf86d6883869f16a46f65</code>,
then the file will be stored in the following path:

	GIT_DIR/objects/ab/04d884140f7b0cf8bbf86d6883869f16a46f65

It pulls the first two characters off and uses that as the subdirectory, so that
there are never too many objects in one directory.  The actual file name is 
the remaining 38 characters.

The easiest way to describe exactly how the object data is stored is this Ruby
implementation of object storage:

	ruby
	def put_raw_object(content, type)
	  size = content.length.to_s
 
	  header = "#{type} #{size}\\0" # type(space)size(null byte)
	  store = header + content
           
	  sha1 = Digest::SHA1.hexdigest(store)
	  path = @git_dir + '/' + sha1[0...2] + '/' + sha1[2..40]
 
	  if !File.exists?(path)
	    content = Zlib::Deflate.deflate(store)
 
	    FileUtils.mkdir_p(@directory+'/'+sha1[0...2])
	    File.open(path, 'w') do |f|
	      f.write content
	    end
	  end
	  return sha1
	end

### Packed Objects ###

The other format for object storage is the packfile. Since Git stores each 
version of each file as a seperate object, it can get pretty inefficient. 
Imagine having a file several thousand lines long and changing a single line.
Git will store the second file in it's entirety, which is a great big waste
of space.

In order to save that space, Git utilizes the packfile.  This is a format
where Git will only save the part that has changed in the second file, with 
a pointer to the file it is similar to.  

When objects are written to disk, it is often in the loose format, since
that format is less expensive to access.  However, eventually you'll want
to save the space by packing up the objects - this is done with the 
linkgit:git-gc[1] command.  It will use a rather complicated heuristic to 
determine which files are likely most similar and base the deltas off that
analysis.  There can be multiple packfiles, they can be repacked if neccesary
(linkgit:git-repack[1]) or unpacked back into loose files 
(linkgit:git-unpack-objects[1]) relatively easily. 

Git will also write out an index file for each packfile that is much smaller 
and contains offsets into the packfile to more quickly find specific objects 
by sha.

The actual details of the packfile implementation are found in the Packfile
chapter a little later on.


