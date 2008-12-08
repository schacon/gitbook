## Navegando nos Objetos Git ##

Podemos perguntar ao git sobre objetos particulares com o comando cat-file.
Veja que você pode encurtar os shas em somente alguns caracteres para
economizar a digitação de todos os 40 digitos hexadecimais.

    $ git-cat-file -t 54196cc2
    commit
    $ git-cat-file commit 54196cc2
    tree 92b8b694ffb1675e5975148e1121810081dbdffe
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500

    initial commit

Uma árvore pode referenciar um ou mais objetos "blob", cada um correspondendo
a um arquivo. Além disso, uma árvore pode também referenciar para outros objetos
tree, desta maneira criando uma hierarquia de diretórios. Você pode examinar o 
conteúdo de qualquer árvore usando ls-tree (lembre-se que uma porção inicial
suficiente do SHA1 também funcionará):

    $ git ls-tree 92b8b694
    100644 blob 3b18e512dba79e4c8300dd08aeb37f8e728b8dad    file.txt

Desse form vemos que a tree possui um arquivo dentro dela. O hash SHA1 é uma
referência para aqueles arquivos de dados:

    $ git cat-file -t 3b18e512
    blob

Um "blob" é só um arquivo de dados, que também podemos examinar com cat-file:

    $ git cat-file blob 3b18e512
    hello world

Veja que esse é um arquivo de dados antigo; então o objeto que o git nomeou dele
corresponde a árvore inicial que era uma tree com o estado do diretório que foi
gravado pelo primeiro commit.     

Todos esses objetos são armazenados sobre seus nomes SHA1 dentro do diretório
do git:

    $ find .git/objects/
    .git/objects/
    .git/objects/pack
    .git/objects/info
    .git/objects/3b
    .git/objects/3b/18e512dba79e4c8300dd08aeb37f8e728b8dad
    .git/objects/92
    .git/objects/92/b8b694ffb1675e5975148e1121810081dbdffe
    .git/objects/54
    .git/objects/54/196cc2703dc165cbd373a65a4dcf22d50ae7f7
    .git/objects/a0
    .git/objects/a0/423896973644771497bdc03eb99d5281615b51
    .git/objects/d0
    .git/objects/d0/492b368b66bdabf2ac1fd8c92b39d3db916e59
    .git/objects/c4
    .git/objects/c4/d59f390b9cfd4318117afde11d601c1085f241

e o conteúdo desses arquivos é só a compressão dos dados mais o header
identificando seu tamanho e seu tipo. O tipo é qualquer entre blob, tree,
commit ou tag.

O commit mais simples que encontra é o commit HEAD, que podemos encontrar no
.git/HEAD:

    $ cat .git/HEAD
    ref: refs/heads/master

Como você pode ver, isso nos diz qual branch estamos atualmente, e nos diz
o caminho completo do arquivo sobre o diretório .git, que nele mesmo contém
o nome SHA1 referindo a um objeto commit, que podemos examinar com cat-file:

    $ cat .git/refs/heads/master
    c4d59f390b9cfd4318117afde11d601c1085f241
    $ git cat-file -t c4d59f39
    commit
    $ git cat-file commit c4d59f39
    tree d0492b368b66bdabf2ac1fd8c92b39d3db916e59
    parent 54196cc2703dc165cbd373a65a4dcf22d50ae7f7
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143418702 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143418702 -0500

    add emphasis

O objeto "tree" aqui se refere ao novo estado da tree:

    $ git ls-tree d0492b36
    100644 blob a0423896973644771497bdc03eb99d5281615b51    file.txt
    $ git cat-file blob a0423896
    hello world!

e o objeto "pai" se refere a um commit anterior:

    $ git-cat-file commit 54196cc2
    tree 92b8b694ffb1675e5975148e1121810081dbdffe
    author J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
    committer J. Bruce Fields <bfields@puzzle.fieldses.org> 1143414668 -0500
