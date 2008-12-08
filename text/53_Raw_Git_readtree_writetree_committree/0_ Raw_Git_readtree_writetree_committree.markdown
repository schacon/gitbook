## Raw Git ##

Aqui daremos uma olhada em como manipular o git em baixo nível, se você por
acaso gostaria de escrever uma ferramenta que gere novos blobs, trees ou commits
de uma forma mais artificial. Se você quer escrever um script que usa a
estrutura de mais baixo nível do git para fazer algo novo, aqui estão algumas
das ferramentas que você precisará.

### Criando Blobs ###

Criar um blob no seu repositório Git e conseguir o SHA é muito fácil.
O comando linkgit:git-hash-object[1] é tudo que você precisará. Para criar um
objeto blob de um arquivo existente, só executar ele com a opção '-w' (que dirá
a ele para escrever o blob, não somente calcular o SHA).

	$ git hash-object -w myfile.txt
	6ff87c4664981e4397625791c8ea3bbb5f2279a3

	$ git hash-object -w myfile2.txt
	3bb0e8592a41ae3185ee32266c860714980dbed7

A saída STDOUT do comando mostrará o SHA do blob que foi criado.    

### Criando Trees ###

Agora digamos que você quer criar um tree de seus novos objetos.
O comando linkgit:git-mktree[1] faz isso de maneira muito simples para gerar
novos objetos tree apartir da saída formatada de linkgit:git-ls-tree[1].
Por exemplo, se você escrever o seguinte para o arquivo chamado '/tmp/tree.txt':

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	file1
	100644 blob 3bb0e8592a41ae3185ee32266c860714980dbed7	file2

e então interligar eles através do commando linkgit:git-mktree[1], o Git
escreverá uma nova tree no banco de dados de objeto e devolverá o novo
sha daquela tree.

	$ cat /tmp/tree.txt | git mk-tree
	f66a66ab6a7bfe86d52a66516ace212efa00fe1f

Então, podemos pegá-lo e fazê-lo um sub-diretório de uma outra tree, e assim em
diante. Se quisermos criar uma nova tree com um deles sendo uma subtree, 
somente criamos um novo arquivo (/tmp/newtree.txt) com o nosso novo SHA com a
tree dentro dele:

	100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3	file1-copy
	040000 tree f66a66ab6a7bfe86d52a66516ace212efa00fe1f	our_files

e então usar linkgit:git-mk-tree[1] novamente:    

	$ cat /tmp/newtree.txt | git mk-tree
	5bac6559179bd543a024d6d187692343e2d8ae83

E agora temos uma estrutura de diretório artificial no Git se parece com isso:    

	.
	|-- file1-copy
	`-- our_files
	    |-- file1
	    `-- file2

	1 diretório, 3 arquivos

sem que a estrutura, tenha na verdade, existido no disco. Mas, nós temos um
SHA (<code>5bac6559</code>) que aponta para ele.

### Rearranjando Trees ###

Podemos também fazer manipulação de tree através da combinação de trees em novas
estruturas usando o arquivo index. Como um exemplo simples, pegamos a tree que
nós já criamos e fazemos uma nova tree que tem duas cópias de nossa tree
<code>5bac6559</code> dentro dela, usando um arquivo index temporário. (Você 
pode fazer isso através de um reset na variável de ambiente GIT_INDEX_FILE ou na
linha de comando) 

Primeiro, lemos a tree dentro de nosso arquivo index sobre um novo prefixo
usando o comando linkgit:git-read-tree[1], e então escrever o conteúdo do index
como uma tree usando o comando linkgit:git-write-tree[1]:

	$ export GIT_INDEX_FILE=/tmp/index
	$ git read-tree --prefix=copy1/  5bac6559
	$ git read-tree --prefix=copy2/  5bac6559
	$ git write-tree 
	bb2fa6de7625322322382215d9ea78cfe76508c1
	
	$>git ls-tree bb2fa
	040000 tree 5bac6559179bd543a024d6d187692343e2d8ae83	copy1
	040000 tree 5bac6559179bd543a024d6d187692343e2d8ae83	copy2

Então agora podemos ver que temos criado uma nova tree somente com a manipulação
do index. Você também pode fazer operações interessantes de merge e de um
index temporário dessa forma - veja a documentação do linkgit:git-read-tree[1]
para mais informações.

### Criando Commits ###

Agora que temos um SHA de uma tree, podemos criar um objeto commit que aponta 
para ele. Podemos fazer isso usando o comando linkgit:git-commit-tree[1]. Muitos
dos dados que vai dentro do commit tem que ser configurado como variáveis de
ambiente, então você gostaria de configurar as seguintes:

	GIT_AUTHOR_NAME
	GIT_AUTHOR_EMAIL
	GIT_AUTHOR_DATE
	GIT_COMMITTER_NAME
	GIT_COMMITTER_EMAIL
	GIT_COMMITTER_DATE

Então você precisará escrever sua mensagem de commit para um arquivo ou de
alguma forma enviá-lo para o comando através do STDIN. Então, você pode criar
seu objeto commit baseado na SHA da tree que temos.

	$ git commit-tree bb2fa < /tmp/message
	a5f85ba5875917319471dfd98dfc636c1dc65650

Se você quer especificar um ou mais commits pais, simplesmente adicione os SHAs
na linha de comando com a opção '-p' antes de cada um. O SHA do novo objeto commit
será retornado vi STDOUT.

### Atualizando o Branch Ref ###

Agora que temos um novo SHA do objeto commit, podemos atualizar um branch para
apontar para ele se quisermos. Digamos que queremos atualizar nosso branch
'master' para apontar para um novo commit que já criamos - usaríamos o comando
linkgit:git-update-ref[1]:

	$ git update-ref refs/heads/master a5f85ba5875917319471dfd98dfc636c1dc65650

