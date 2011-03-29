require 'rubygems'
require 'fileutils'
require 'nokogiri'
require 'rdiscount'
require 'eeepub'

# With a little help from https://github.com/sorah/poignant-guide-epub

task :epub do
  section, chapter = 0, 0
  sections = []
  output = ''
  
  FileUtils.mkdir_p('output/epub')
  
  Dir['text/**/*.markdown'].sort.each do |path|
    markdown = File.new(path).read.gsub(/\</, '&lt;').gsub(/\>/, '&gt;')
    html = RDiscount.new(markdown).to_html
    
    if Nokogiri::HTML(html).css('h1').size > 0
      section += 1
      chapter = 0
      
      sections << {:label => Nokogiri::HTML(html).css('h1').first.content, :content => "gitbook.html#section-#{section}", :nav => []}
      output << %(<a name="section-#{section}"></a>)
    end
    
    if Nokogiri::HTML(html).css('h2').size > 0
      chapter += 1
      
      sections.last[:nav] << {:label => Nokogiri::HTML(html).css('h2').first.content, :content => "gitbook.html#section-#{section}-chapter-#{chapter}"}
      output << %(<a name="section-#{section}-chapter-#{chapter}"></a>)
    end
    
    output << html
  end
  
  File.open('output/epub/gitbook.html', 'w') do |f|
    body = do_replacements(output, :epub)
    html_template = File.new("layout/epub_template.html").read.gsub!("#body", body)
    f << html_template
  end
  
  `cp -Rf assets output/epub/`
  
  assets = ['./output/epub/gitbook.html', {'./output/epub/assets/stylesheets/epub.css' => 'assets/stylesheets'}]
  
  Dir['assets/images/**/*'].each do |path|
    assets << {path => File.dirname(path)} unless File.directory?(path)
  end
  
  epub = EeePub.make do
    title 'Git Community Book'
    creator 'Scott Chacon'
    publisher 'git-scm.com'
    date Time.now.strftime('%Y-%m-%d')
    identifier 'http://book.git-scm.com', :scheme => 'URL'
    uid 'http://book.git-scm.com'
    files assets
    nav sections
  end
  
  epub.save('output/gitbook.epub')
end
