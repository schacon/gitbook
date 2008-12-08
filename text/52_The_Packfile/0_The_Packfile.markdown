## O Packfile ##

Esse capítulo explica em detalhes, a nível de bits, como os arquivos packfile e o 
pack index são formatados.

### O Index do Packfile ###

Primeiro, nós temos o index do packfile, que é basicamente só uma série de
bookmarks dentro do packfile.

Existem duas versões de index do packfile - versão um, que é a padrão nas versões
anteriores do Git 1.6, e a versão dois, que é o padrão a partir da 1.6, mas que
pode ser lida pelas versões do Git de volta a 1.5.2, e tem sido implementado de
volta para a 1.4.4.5 se você está usando sobre a série 1.4.

Versão 2 também inclui uma checagem de CRC de cada objeto então dados
comprimidos podem ser copiados diretamente de um packfile para outro durante o 
re-empacotamento sem precisar detectar corrupção de dados. Indexes versão 2
também podem manipular packfiles maiores que 4GB.

[fig:packfile-index]

Em ambos formatos, a tabela fanout é simplesmente uma forma de encontrar o 
deslocamento de um sha particular mais rápido dentro do arquivo index. As 
tabelas de offset/sha1[] são ordenados por valores sha1[] (isso permite
busca binária nessa tabela), e a tabela fanout[] aponta para a tabela 
offset/sha1[] de uma forma específica (para que parte da última tabela que 
cobre todos os hashes que iniciam com o byte dado pode ser encontrado para 
evitar 8 interações da busca binária).

Na versão 1, os offsets e shas estão no mesmo espaço, na versão 2, existem
tabelas separadas para shas, CRCs e offsets. No final de ambos os arquivos 
estão as shas para ambos os arquivos de index e packfile que ele referencia.

Importante, indexes de packfile *não* são necessários para extrair objetos de 
um packfile, eles são simplesmente usados para acessar *rapidamente* objetos
individuais de um pacote.

### O formato do Packfile ###

O packfile em si é um formato muito simples. Existe um cabeçalho, uma série de
pacotes de objetos (cada um com o seu próprio cabeçalho e corpo) e o checksum.
Os primeiros quatro bytes é a string 'PACK', que dá um pouco de certeza que você
está conseguindo o início de um packfile corretamente. Isso é seguido por um
número de versão de 4 bytes do packfile e então um número de 4 bytes de entrada
nesse arquivo. Em Ruby, você pode ler os dados do cabeçalho assim:

	ruby
	def read_pack_header
	  sig = @session.recv(4)
	  ver = @session.recv(4).unpack("N")[0]
	  entries = @session.recv(4).unpack("N")[0]
	  [sig, ver, entries]
	end

Depois que, você consegue uma série de objetos empacotados, na ordem de seus SHAs
que cada um consiste de um object header e object contents. No final do packfile é
uma soma SHA1 de 20 bytes de todos os SHAs (ordenados) naquele packfile.

[fig:packfile-format]

O object header é uma série de um ou mais bytes (8 bits) que especifica o tipo
do objeto de acordo como os dados são, com o primeiro bit existente dizendo se
aquele conjunto é o último ou não antes do início dos dados. Se o primeiro bit
é o 1, você lerá outro byte, senão os dados iniciariam logo depois. Os 3 
primeiros bits no primeiro byte especifica o tipo do dado, de acordo com a 
tabela a seguir.

(Atualmente, dos 8 valores que podem ser expressados com 3 bits (0-7), 0 (000)
é 'não definido' e 5 (101) é não usado ainda.)

Aqui, nós podemos ver um exemplo do cabeçalho de dois bytes, onde o primeiro
especifica que o seguinte dado é um commit, e o restante do primeiro e os 
últimos 7 bits do segundo especifica que os dados terão 144 bytes quando
expandidos.

[fig:packfile-logic]

Isso é importante notar que o tamanho especificado no cabeçalho não é o
tamanho dos dados que na verdade segue, mas o tamanho do dado *quando
expandido*. Isso é porque os offsets no index do packfile são tão úteis,
senão você tem que expandir cada objeto só para dizer quando o próximo
cabeçalho inicia.

A parte de dados é só uma stream zlib para tipos de objetos não-delta; para
as duas representações de objetos delta, a porção de dados contém algo que 
identifica que objeto base essa representação do delta depende, e o delta
para aplicar sobre o objeto base para ressucitar esse objeto.
<code>ref-delta</code> usa um hash de 20 bytes do objeto base no início dos dados,
enquanto <code>ofs-delta</code> armazena um offset dentro do mesmo packfile para 
identificar o objeto base. Em qualquer caso, duas importantes restrições devem ser
aderidas: 

delta to apply on the base object to resurrect this object.  <code>ref-delta</code>
uses 20-byte hash of the base object at the beginning of data, while
<code>ofs-delta</code> stores an offset within the same packfile to identify the base
object.  In either case, two important constraints a reimplementor must
adhere to are:

* representação delta deve ser baseado em algum outro objeto dentro do mesmo packfile;

* o objeto base deve ser o mesmo tipo subjacebte (blob, tree, commit
  ou tag);