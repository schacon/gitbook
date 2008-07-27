require 'rubygems'
require 'rdiscount'
require "uv"

desc 'Create the HTML version'
task :html => :merge do
  if File.exists?('output/full_book.markdown')
    output = File.new('output/full_book.markdown').read
    output = RDiscount.new(output).to_html

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
  end
end
