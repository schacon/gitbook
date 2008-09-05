require 'fileutils'
require 'pp'
require 'rubygems'
require 'builder'
require 'rdiscount'
require "uv"

#MIN_SIZE = 1200
MIN_SIZE = 800

def do_replacements(html, type = :html)

  # highlight code
  html = html.gsub /<pre><code>ruby.*?<\/code><\/pre>/m do |code|
    code = code.gsub('<pre><code>ruby', '').gsub('</code></pre>', '').gsub('&lt;', '<').gsub('&gt;', '>').gsub('&amp;', '&')
    Uv.parse(code, "xhtml", "ruby", false, "mac_classic")
  end

  # replace gitlinks
  html.gsub! /linkgit:(.*?)\[\d\]/ do |code, waa|
    "<a href=\"http://www.kernel.org/pub/software/scm/git/docs/#{$1}.html\">#{$1.gsub('git-', 'git ')}</a>"
  end
  
  # replace figures
  html.gsub! /\[fig:(.*?)\]/, '<div class="center"><img src="images/figure/\1.png"></div>'
  
  # fix images in pdf
  html.gsub!('src="images', 'src="assets/images')

  # replace/remove gitcasts
  
  html = html.gsub /\[gitcast:.*?\]\(.*?\)/ do |code|
    if type == :html
      puts code
      if match = /gitcast:(.*?)\]\((.*?)\)/.match(code)
        cast = match[1].gsub('_', '%2D')
        code = '<div class="gitcast">
        <embed src="http://gitcasts.com/flowplayer/FlowPlayerLight.swf?config=%7Bembedded%3Atrue%2CbaseURL%3A%27http%3A%2F%2Fgitcasts%2Ecom%2Fflowplayer%27%2CvideoFile%3A%27http%3A%2F%2Fmedia%2Egitcasts%2Ecom%2F' + cast + '%2Eflv%27%2CautoBuffering%3Afalse%2CautoPlay%3Afalse%7D" width="620" height="445" scale="noscale" bgcolor="111111" type="application/x-shockwave-flash" allowFullScreen="true" allowScriptAccess="always" allowNetworking="all" pluginspage="http://www.macromedia.com/go/getflashplayer"></embed>
        <br>' +  match[2] + '
        </div>'
      end
    else
      code = ''
    end
    code
  end
  
  html
end

desc 'Create the HTML version'
task :html => :merge do
  
  if File.exists?('output/full_book.markdown')
    output = File.new('output/full_book.markdown').read
    output = RDiscount.new(output).to_html

    ## pdf version ##
    
    # code highlighting
    File.open('output/index.html', 'w') do |f|
      body = do_replacements(output, :pdf)

      html_template = File.new("layout/pdf_template.html").read
      html_template.gsub!("#body", body)

      
      f.puts html_template
    end
    
    ## html version ##
    
    html_dir = 'output/book'
    FileUtils.rm_r(html_dir) rescue nil
    Dir.mkdir(html_dir)
    
    # html chapters
    links = []
    chapter_files = []
    
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
        body = "<h2>#{chtitle}</h2>" + chapter
        body = do_replacements(body, :html)
        chlinks << [chtitle.strip, filename, body.size]
        chapter_files << [chtitle.strip, filename, body]
      end
      links << [title.strip, chlinks]
    end

    # writing out the chapter files
    chapter_files.each_with_index do |arr, index|
      chapter_title, chapter_file, body = arr
      File.open(File.join(html_dir, chapter_file), 'w') do |f|
        nav = ''
        if (cf = chapter_files[index - 1]) && index != 0
          nav += "<a href=\"#{cf[1]}\">Prev</a> "
        end
        if cf = chapter_files[index + 1]
          nav += " <a href=\"#{cf[1]}\">Next</a>"
        end
        html_template = File.new("layout/chapter_template.html").read
        html_template.gsub!("#title", chapter_title)
        html_template.gsub!("#body", body)
        html_template.gsub!("#nav", nav)
        f.puts html_template
      end
    end
    
    toc = Builder::XmlMarkup.new(:indent => 1)
    toc.table { toc.tr { 
      toc.td(:valign => "top") {
        links[0,4].each do |section_title, section_array|
          toc.h3(:class => 'title') { toc << section_title }
          toc.table do
            section_array.each do |chapter_title, chapter_file, chsize|
              toc.tr { toc.td {
                (chsize > MIN_SIZE) ? extra = 'done' : extra = 'todo'
                toc.a(:href => chapter_file, :class => "chapter-link #{extra}") << chapter_title
              }}
            end
          end
        end
      }
      toc.td(:valign => "top") {
        links[4,3].each do |section_title, section_array|
          toc.h3(:class => 'title') { toc << section_title }
          toc.table do
            section_array.each do |chapter_title, chapter_file, chsize|
              toc.tr { toc.td {
                (chsize > MIN_SIZE) ? extra = 'done' : extra = 'todo'
                toc.a(:href => chapter_file, :class => "chapter-link #{extra}") << chapter_title
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
    
    `cp -Rf assets output/book/`
    `cp output/book.pdf output/book/`
    
  end
end

