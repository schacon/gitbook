desc 'Merge all of the texttile output into a single file for pdf conversion'

task :merge do
  File.open('output/full_book.markdown', 'w+') do |f|
    Dir["text/**/*.markdown"].sort.each do |path|
      f << File.new(path).read + "\r\n"
    end
  end
end
