## Protocolos de Transferência ##

Aqui vamos examinar como os clientes e servidores falam um com o outro para
transferir todos os dados do Git.

### Recuperando Dados sobre HTTP ###

Recuperar sobre URL http/s fará o Git usar um protocolo ligeiramente simples.
Nesse caso, todo a lógica está inteiramente no lado do cliente. Não requer nenhuma
configuração especial no servidor - qualquer webserver estático funcionará bem se
o diretório do git que você está recuperando está no caminho do webserver.

Segundo as regras, para isso funcionar você precisa excutar um simples comando sobre
o repositório do servidor cada vez que alguma coisa for atualizada, mesmo assim - 
linkgit:git-update-server-info[0], que atualiza os arquivos objects/info/packs
e info/refs para listar quais refs e packfiles estão disponíveis, desde que não possa
realizar uma listagem sobre http. Quando o comando executa, o arquivo
objects/info/packs se parece como algo assim:

	P pack-ce2bd34abc3d8ebc5922dc81b2e1f30bf17c10cc.pack
	P pack-7ad5f5d05f5e20025898c95296fe4b9c861246d8.pack

Para que, se o fetch não poder encontrar um arquivo loose, ele pode tentar esses
packfiles. O arquivo info/refs se parecerá assim:

	184063c9b594f8968d61a686b2f6052779551613	refs/heads/development
	32aae7aef7a412d62192f710f2130302997ec883	refs/heads/master

Então quando você recuperar desse repositório, ele iniciará com esses refs e
percorrerá os objetos commits até o cliente ter todos os objetos que ele precisa.

Por exemplo, se você pedir para recuperar o branch master, ele verá que o master
está apontando para <code>32aae7ae</code> e que o seu master está apontando para
<code>ab04d88</code>, então você precisa do <code>32aae7ae</code>. Você recupera
aquele objeto

	CONNECT http://myserver.com
	GET /git/myproject.git/objects/32/aae7aef7a412d62192f710f2130302997ec883 - 200

e ele se parecerá com isso:	
and it looks like this:

	tree aa176fb83a47d00386be237b450fb9dfb5be251a
	parent bd71cad2d597d0f1827d4a3f67bb96a646f02889
	author Scott Chacon <schacon@gmail.com> 1220463037 -0700
	committer Scott Chacon <schacon@gmail.com> 1220463037 -0700

	added chapters on private repo setup, scm migration, raw git

Então agora ele recupera a tree <code>aa176fb8</code>:   

	GET /git/myproject.git/objects/aa/176fb83a47d00386be237b450fb9dfb5be251a - 200

que se parecerá com isso:    

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	COPYING
	100644 blob 97b51a6d3685b093cfb345c9e79516e5099a13fb	README
	100644 blob 9d1b23b8660817e4a74006f15fae86e2a508c573	Rakefile

Então ele recupera aqueles objetos:    

	GET /git/myproject.git/objects/6f/f87c4664981e4397625791c8ea3bbb5f2279a3 - 200
	GET /git/myproject.git/objects/97/b51a6d3685b093cfb345c9e79516e5099a13fb - 200
	GET /git/myproject.git/objects/9d/1b23b8660817e4a74006f15fae86e2a508c573 - 200

Ele na verdade faz isso com Curl, e pode abrir múltiplos threads paralelos para
aumentar a velocidade desse processo. Quando ele termina recursando a tree
apontado pelo commit, ele recupera o próximo pai.
	
	GET /git/myproject.git/objects/bd/71cad2d597d0f1827d4a3f67bb96a646f02889 - 200

Agora nesse caso, o commit que chega se parece com isso:    

	tree b4cc00cf8546edd4fcf29defc3aec14de53e6cf8
	parent ab04d884140f7b0cf8bbf86d6883869f16a46f65
	author Scott Chacon <schacon@gmail.com> 1220421161 -0700
	committer Scott Chacon <schacon@gmail.com> 1220421161 -0700

	added chapters on the packfile and how git stores objects

e podemos ver que o pai, <code>ab04d88</code> é onde nosso branch master está 
atualmente apontando. Então, recursivamente recuperamos essa tree e então para,
desde que sabemos que temos tudo antes desse ponto. Você pode forçar o Git para
realizar uma dupla checagem do que temos com a opção '--recover'. Veja 
linkgit:git-http-fetch[1] para mais informações.

Se a recuperação de um dos objetos loose falha, o Git baixa o índice do packfile
procurando pelo sha que ele precisa, então baixa esse packfile.

Isso é importante se você está executando um servidor git que serve repositórios
desta forma para implementar um hook post-receive que executará o comando 
'git update-server-info' cada vez ou haverá confusão.

### Recuperando Dados com Upload Pack ###

Para protocolos espertos, recuperar objetos é muito mais eficiente. Um socket
é aberto, também sobre ssh ou porta 9418 (nesse caso o protocolo git://),
e o comando linkgit:git-fetch-pack[1] no cliente inicia a comunicação com um
processo filho no servidor do linkgit:git-upload-pack[1].

Então o servidor pedirá ao clente que SHAs ele tem para cada ref, e o cliente
entende que ele precisa e responde com a lista de SHAs que ele quer e já possue.

Ness ponto, o servidor gerará um packfile com todos os objetos que o cliente
precisa e iniciando a transferência para o cliente.

Vamos dar uma olhada em um exemplo.

O cliente conecta e enviar um cabeçalho de requisição. O comando clone

	$ git clone git://myserver.com/project.git

produz a seguinte requisição:

	0032git-upload-pack /project.git\\000host=myserver.com\\000

Os primeiros quatros bytes contém o tamanho em hexadecimal da linha (incluindo 
os 4 bytes e removendo caracter de nova linha se existir). Seguindo estão o
comando e os argumentos. Isso é seguido por um byte null e então a informação
do host. A requisição é terminada por um byte null.

A requisição é processada e transformado em uma chamada para git-upload-pack:

 	$ git-upload-pack /path/to/repos/project.git

Isso imediatamente retorna a informação do repositório:    

	007c74730d410fcb6603ace96f1dc55ea6196122532d HEAD\\000multi_ack thin-pack side-band side-band-64k ofs-delta shallow no-progress
	003e7d1665144a3a975c05f1f43902ddaf084e784dbe refs/heads/debug
	003d5a3f6be755bbb7deae50065988cbfa1ffa9ab68a refs/heads/dist
	003e7e47fe2bd8d01d481f44d7af0531bd93d3b21c01 refs/heads/local
	003f74730d410fcb6603ace96f1dc55ea6196122532d refs/heads/master
	0000

Cada linha inicia com uma declaração em hexadecimal de quatro bytes. A seção é
terminada por uma declaração de 0000.    

Isso é enviado de volta para o cliente textualmente. O cliente responde com outra
requisição:

	0054want 74730d410fcb6603ace96f1dc55ea6196122532d multi_ack side-band-64k ofs-delta
	0032want 7d1665144a3a975c05f1f43902ddaf084e784dbe
	0032want 5a3f6be755bbb7deae50065988cbfa1ffa9ab68a
	0032want 7e47fe2bd8d01d481f44d7af0531bd93d3b21c01
	0032want 74730d410fcb6603ace96f1dc55ea6196122532d
	00000009done

É enviado para abrir o processo git-upload-pack que então envia a reposta final:    

	"0008NAK\n"
	"0023\\002Counting objects: 2797, done.\n"
	"002b\\002Compressing objects:   0% (1/1177)   \r"
	"002c\\002Compressing objects:   1% (12/1177)   \r"
	"002c\\002Compressing objects:   2% (24/1177)   \r"
	"002c\\002Compressing objects:   3% (36/1177)   \r"
	"002c\\002Compressing objects:   4% (48/1177)   \r"
	"002c\\002Compressing objects:   5% (59/1177)   \r"
	"002c\\002Compressing objects:   6% (71/1177)   \r"
	"0053\\002Compressing objects:   7% (83/1177)   \rCompressing objects:   8% (95/1177)   \r"
	...
	"005b\\002Compressing objects: 100% (1177/1177)   \rCompressing objects: 100% (1177/1177), done.\n"
	"2004\\001PACK\\000\\000\\000\\002\\000\\000\n\\355\\225\\017x\\234\\235\\216K\n\\302"...
	"2005\\001\\360\\204{\\225\\376\\330\\345]z\226\273"...
	...
	"0037\\002Total 2797 (delta 1799), reused 2360 (delta 1529)\n"
	...
	"<\\276\\255L\\273s\\005\\001w0006\\001[0000"

Veja o capítulo anteriormente sobre Packfile para o formato real dos dados do
packfile nessa resposta.
	
### Enviando Dados ###

Enviar dados sobre os protocolos git ou ssh são similares, mas simples. 
Basicamente o que acontece é o cliente requisitar uma instância de receive-pack,
que está iniciado se o cliente tem acesso, então o servidor retorna todos os SHAs
do ref heads dele tem novamente o cliente gera o packfile de tudo que o servidor 
precisa(geralmente somente se o que está no servidor é um ancestral direto do que
é enviado) e envia esse fluxo do packfile, onde o servidor também armazena ele no
disco e constroi um index para ele, ou desempacota ele (se não existe muitos
objetos nele)

Esse proceso inteiro é realizado através do comando linkgit:git-send-pack[1] no
cliente, que é invocado pelo comando linkgit:git-push[1] e o linkgit:git-receive-pack[1]
no lado do servidor, que é invocado pelo processo de conexão ssh ou daemon git
(se ele é um servidor aberto para envio)


