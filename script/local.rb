require 'rubygems'
require 'mongrel'

h = Mongrel::HttpServer.new("0.0.0.0", "4001")
h.register("/", Mongrel::DirHandler.new("output/book"))
h.run.join
