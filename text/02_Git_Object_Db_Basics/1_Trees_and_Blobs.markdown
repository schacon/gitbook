### Objeto Blob ###

Um blob geralmente armazena o conteúdo de um arquivo.

[fig:object-blob]

Você pode usar linkgit:git-show[1] para examinar o conteúdo de qualquer blob.
Supondo que temos um SHA para um blob, podemos examinar seu conteúdo assim:

    $ git show 6ff87c4664

     Note that the only valid version of the GPL as far as this project
     is concerned is _this_ particular version of the license (ie v2, not
     v2.2 or v3.x or whatever), unless explicitly otherwise stated.
    ...

Um objeto "blob" não é nada mais que um grande pedaço de dados binários. Ele
não se referencia a nada ou possue atributos de qualquer tipo, nem mesmo um nome
de arquivo.  

Desde que o blob é inteiramente definido por esses dados, se dois arquivos em 
uma árvore de diretório (ou dentro de múltiplas versões diferentes desse 
repositório) possui o mesmo conteúdo, eles irão compartilhar o mesmo objeto 
blob. O objeto é totalmente independente da localização do arquivo na árvore de 
diretório, e renomeando esse arquivo não muda o objeto com o qual está  
associado.


### Objeto Tree ###

Um tree é um objeto simples que possui um conjunto de ponteiros para blobs e 
outras trees - ele geralmente representa o conteúdo de um diretório ou sub 
diretório.

[fig:object-tree]

O sempre versátil comando linkgit:git-show[1] pode também ser usado para 
examinar objetos tree, mas linkgit:git-ls-tree[1] dará a você mais detalhes.
Supondo que temos um SHA para uma tree, podemos examinar ele assim:

    $ git ls-tree fb3a8bdd0ce
    100644 blob 63c918c667fa005ff12ad89437f2fdc80926e21c    .gitignore
    100644 blob 5529b198e8d14decbe4ad99db3f7fb632de0439d    .mailmap
    100644 blob 6ff87c4664981e4397625791c8ea3bbb5f2279a3    COPYING
    040000 tree 2fb783e477100ce076f6bf57e4a6f026013dc745    Documentation
    100755 blob 3c0032cec592a765692234f1cba47dfdcc3a9200    GIT-VERSION-GEN
    100644 blob 289b046a443c0647624607d471289b2c7dcd470b    INSTALL
    100644 blob 4eb463797adc693dc168b926b6932ff53f17d0b1    Makefile
    100644 blob 548142c327a6790ff8821d67c2ee1eff7a656b52    README
    ...

Como você pode ver, um objeto tree contém uma lista de entradas, cada uma com um 
modo de acesso, tipo, nome SHA1, e nome de arquivo, ordenado pelo nome de 
arquivo. Ele representa o conteúdo de uma simples árvore de diretório.

Um objeto referenciado por uma tree pode ser um blob, representando o conteúdo
de um arquivo, ou outra tree, representando o conteúdo de um sub diretório. 
Desde trees e blobs, como todos os outros objetos, são nomeados por um hash SHA1
de seus conteúdos, duas trees possui o mesmo hash SHA1 se somente se seus 
conteúdos (incluindo, recursivamente, o conteúdo de todos os sub diretórios) são
idênticos.
Isso permite ao git determinar rapidamente as diferenças entre dois objetos tree
,desde que ele possa ignorar qualquer entrada com nome de objetos idênticos.  

(Nota: na presença de sub módulos, trees pode também ter commits como entradas. 
veja a seção **Sub Módulos**.)

Perceba que todos os arquivos possuem o modo de acesso 644 ou 755: git 
normalmente dá atenção para o bit executável. 
