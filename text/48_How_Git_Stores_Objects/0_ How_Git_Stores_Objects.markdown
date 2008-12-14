## Como o Git Armazena Objetos ##

Esse capítulo mostra em detalhes como o Git fisicamente armazenda os objetos.

Todos os objetos são armazenados pela compressão do conteúdo de acordo com os
seus valores sha. Eles contém o tipo de objeto, tamanho e conteúdo no formato
gzip.

Existem dois formatos que o Git mantém os objetos - objetos loose e packed.

### Objetos Loose ###

Objetos loose é o formato mais simples. Ele é simplesmente a compressão dos dados
armazenados em um simples arquivo no disco. Cada objeto é escrito em um arquivo
separado.

Se o sha do seu objeto é <code>ab04d884140f7b0cf8bbf86d6883869f16a46f65</code>,
então o arquivo será armazenado com o seguinte caminho:

	GIT_DIR/objects/ab/04d884140f7b0cf8bbf86d6883869f16a46f65

Ele retira os dois primeiros caracteres e usa-o como sub-diretório, para que
nunca exista muitos objetos em um diretório. O nome do arquivo na verdade é o
restante dos 38 caracteres.

A forma mais fácil de descrever exatamente como os dados do objeto são
armazenados é essa implementação em Ruby do armazenamento do objeto:

	ruby
	def put_raw_object(content, type)
	  size = content.length.to_s

	  header = "#{type} #{size}\0"
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

### Objetos Packed ###

O outro formato para o armazenamento de objetos é o packfile. Visto que o Git
armazena cada versão do arquivo em um objeto separado, isso pode ser bastante
ineficiente.
Imagine tendo um arquivo com milhares de linhas e então altera uma simples linha.
Git armazenará o segundo arquivo inteiramente nele, que é um grande desperdício
de espaço.

Segundo as regras para a economia de espaço, Git utiliza o packfile. Esse é um
formato onde o Git somente gravará a parte que foi alterada no segundo arquivo,
com um apontador para o arquivo original.

Quando os objetos são escritos no disco, frquentemente é no formato loose,
desde que o formato seja menos dispendioso para acessar. Contudo, finalmente
você irá querer economizar espaço através do empacotamento dos objetos - isso
é feito com o comando linkgit:git-gc[1]. Ele usará uma heurística bastante
complicada para determinar quais arquivos são provavelmente mais semelhantes e
e basear os deltas dessa análise. Podem ser múltiplos packfiles, eles podem ser
re-empacotados se necessário (linkgit:git-repack[1]) ou desempacotados de volta
em arquivos loose (linkgit:git-unpack-objects[1]) com relativa facilidade.

Git também escreverá um arquivo index para cada packfile que é muito menor e
contém o deslocamento dentro do packfile para rapidamente encontrar objetos
específicos através do sha.

Os detalhes exatos da implementação do packfile são encontrados no capítulo
Packfile um pouco mais tarde.
