## Branching e Merging Avançados ##

### Conseguindo ajuda na resolução de conflitos durante o merge ###

Todas as alterações que o git foi capaz de realizar o merge automaticamente
já estão adicionadas no arquivo index, então linkgit:git-diff[1] mostrará 
somente os conflitos. Ele usa uma sintaxe incomum:

    $ git diff
    diff --cc file.txt
    index 802992c,2b60207..0000000
    --- a/file.txt
    +++ b/file.txt
    @@@ -1,1 -1,1 +1,5 @@@
    ++<<<<<<< HEAD:file.txt
     +Hello world
    ++=======
    + Goodbye
    ++>>>>>>> 77976da35a11db4580b80ae27e8d65caf5208086:file.txt

Recorde que depois que o commit resolver esse conflito terão dois pais ao invés
de um como de costume: um pai será o HEAD, a ponta do branch atual; o outro 
será a ponta do outro branch, que é armazenado temporariamente no MERGE_HEAD.

Durante o merge, o index retém três versões de cada arquivo. Cada um desses
três "estágios do arquivo" representam uma versão diferente do arquivo:

	$ git show :1:file.txt	# o arquivo é o ancestral comum de ambos os branches
	$ git show :2:file.txt	# a versão do HEAD.
	$ git show :3:file.txt	# a versão do MERGE_HEAD.

Quando você pergunta ao linkgit:git-diff[1] para mostrar os conflitos, ele 
executa um diff de três-passos entre os resultados do merge conflitantes na
árvore de trabalho com o estágio 2 e 3 para mostrar somente de qual o conteúdo
vem de ambos os lados, misturados (em outras palavras, quando o resultado do 
merge vem somente do estágio 2, que parte não está conflitando e não é 
mostrada. Mesmo para o estágio 3).

O diff acima mostra a diferença entre a versão da árvore de trabalho do file.txt
e as versões do estágio 2 e estágio 3. Então ao invés de preceder cada linha
com um simples "+" ou "-", ele agora usa duas colunas: a primeira coluna é 
usada para diferenciar entre o primeiro pai e a cópia do diretório de trabalho
atual, e o segundo para diferenciar entre o segungo pai e a cópia do diretório 
de trabalho. (Veja a seção "COMBINED DIFF FORMAT" do linkgit:git-diff-files[1]
para mais detalhes do formato.)

Depois da resolução dos conflitos de forma óbvia (mas antes de atualizar o 
index), o diff se parecerá com isso:

    $ git diff
    diff --cc file.txt
    index 802992c,2b60207..0000000
    --- a/file.txt
    +++ b/file.txt
    @@@ -1,1 -1,1 +1,1 @@@
    - Hello world
    -Goodbye
    ++Goodbye world

Isso mostra que nossa versão corrigida apagou "Hello world" do primeiro
pai, apagou "Goodbye" do segundo pai, e adicionou "Goodbye world", que estava
ausente de ambos anteriormente. 

Algumas opções especiais do diff permitem diferenciar o diretório de trabalho 
contra qualquer estágio:

    $ git diff -1 file.txt		# diff contra o estágio 1
    $ git diff --base file.txt	# mesmo como acima
    $ git diff -2 file.txt		# diff contra o estágio 2
    $ git diff --ours file.txt	# mesmo como acima
    $ git diff -3 file.txt		# diff contra o estágio 3
    $ git diff --theirs file.txt	# mesmo como acima

Os comandos linkgit:git-log[1] e linkgit:gitk[1] também provêm ajuda especial
para merges:

    $ git log --merge
    $ gitk --merge

Isso mostrará todos os commits que existem somente sobre HEAD ou sobre 
MERGE_HEAD, e qual tocou em um arquivo sem merge.

Você também pode usar linkgit:git-mergetool[1], que deixa você realizar o 
merge de arquivos sem merge usando ferramentas externas como emacs ou kdiff3.

Cada vez que você resolve os conflitos dentro do arquivo e atualiza o index:

    $ git add file.txt

os diferentes estágios daquele arquivo será "collapsed", depois que git-diff
não mostrar (por padrão) diferenças para aquele arquivo.