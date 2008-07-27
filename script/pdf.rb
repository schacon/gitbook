desc 'Cria um arquivo pdf à partir do html gerado'
task :pdf => :html do
  prince = Prince.new()
  html_string = File.new("output/index.html").read
  prince.add_style_sheets 'layout/second.css', 'layout/mac_classic.css'
  
  File.open('output/book.pdf', 'w') do |f|
    f.puts prince.pdf_from_string(html_string)
  end
  
  `open output/book.pdf`
end