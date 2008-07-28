require 'fileutils'
require 'pp'
require 'rubygems'
require 'builder'
require 'rdiscount'
require "uv"

desc 'Create the HTML version'
task :html => :merge do
  if File.exists?('output/full_book.markdown')
    output = File.new('output/full_book.markdown').read
    output = RDiscount.new(output).to_html

    ## pdf version ##
    
    # code highlighting
    File.open('output/index.html', 'w') do |f|
      html_template = File.new("layout/pdf_template.html").read
      html_template.gsub!("#body", output)
      html_template.gsub! /<pre><code>.*?<\/code><\/pre>/m do |code|
        code = code.gsub('<pre><code>', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
        Uv.parse(code, "xhtml", "ruby", false, "mac_classic")
      end
      f.puts html_template
    end
    
    ## html version ##
    
    html_dir = 'output/book'
    FileUtils.rm_r(html_dir) rescue nil
    Dir.mkdir(html_dir)
    
    # html chapters
    links = []
    count = 0
    sections = output.split('<h1>')
    sections.each do |section|
      # extract title
      title, section = section.split('</h1>')
      next if !section
      count += 1
      title = count.to_s + '. ' + title.strip
      puts title
      
      chlinks = []
      chapters = section.split('<h2>')
      chapters.shift
      chapters.each do |chapter|
        chtitle, chapter = chapter.split('</h2>')
        next if !chapter
        # extract chapter title
        puts "\t" + chtitle.strip
        filename = count.to_s + '_' + chtitle.strip.downcase.gsub(' ', '_') + '.html'
        File.open(File.join(html_dir, filename), 'w') do |f|
          body = "<h2>#{chtitle}</h2>" + chapter
          html_template = File.new("layout/chapter_template.html").read
          html_template.gsub!("#title", chtitle)
          html_template.gsub!("#body", body)
          f.puts html_template
        end
        chlinks << [chtitle.strip, filename]
      end
      links << [title.strip, chlinks]
    end
    
    toc = Builder::XmlMarkup.new(:indent => 1)
    toc.table { toc.tr { 
      toc.td(:valign => "top") {
        links[0,4].each do |section_title, section_array|
          toc.h1 { toc << section_title }
          toc.table do
            section_array.each do |chapter_title, chapter_file|
              toc.tr { toc.td {
                toc.a(:href => chapter_file) << chapter_title
              }}
            end
          end
        end
      }
      toc.td(:valign => "top") {
        links[4,3].each do |section_title, section_array|
          toc.h1 { toc << section_title }
          toc.table do
            section_array.each do |chapter_title, chapter_file|
              toc.tr { toc.td {
                toc.a(:href => chapter_file) << chapter_title
              }}
            end
          end
        end
      }
    }}    
    File.open('output/book/index.html', 'w') do |f|
      html_template = File.new("layout/book_index_template.html").read
      html_template.gsub!("#body", toc.to_s)
      f.puts html_template
    end
    
  end
end
