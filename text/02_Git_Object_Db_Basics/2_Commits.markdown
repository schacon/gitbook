### Objeto Commit ###

O objeto "commit" liga o estado físico de uma árvore com a descrição de como 
a conseguimos e porque.

[fig:object-commit]

Você pode usar a opção --pretty=raw para linkgit:git-show[1] ou 
linkgit:git-log[1] para examinar seu commit favorito: 

    $ git show -s --pretty=raw 2be7fcb476
    commit 2be7fcb4764f2dbcee52635b91fedb1b3dcf7ab4
    tree fb3a8bdd0ceddd019615af4d57a53f43d8cee2bf
    parent 257a84d9d02e90447b149af58b271c19405edb6a
    author Dave Watson <dwatson@mimvista.com> 1187576872 -0400
    committer Junio C Hamano <gitster@pobox.com> 1187591163 -0700

        Fix misspelling of 'suppress' in docs

        Signed-off-by: Junio C Hamano <gitster@pobox.com>

Como você pode ver, um commit é definido por:

- uma **tree**: O nome SHA1 do objeto tree (como definido acima), representando
  o conteúdo de um diretório em um certo ponto no tempo. 
- **parent(s)**: O nome SHA1 de algum número de commits que representa 
  imediatamente o(s) passo(s) anterior(es) na história do projeto. O exemplo 
  acima possui um parent; commits gerados por um merge podem ter mais do que um. 
  Um commit sem nenhum parent é chamado de commit "root", e representa a 
  versão/revisão inicial do projeto. Cada projeto deve possuir pelo menos um 
  root. Um projeto pode também ter múltiplos roots, mesmo assim não é comum
  (ou necessariamente uma boa idéia).
- um **author**: O nome da pessoa responsável pela alteração, junto com uma 
  data. 
- um **committer**: O nome da pessoa que de fato criou o commit, com a data
  que foi feita. Ele pode ser diferente do autor, por exemplo, se o autor 
  escreveu um patch e enviou-o para outra pessoa que usou o patch para criar o
  commit.  
- um **comment** descrevendo esse commit.

Note que um commit não contém qualquer informação sobre o que foi alterado;
todas as alterações são calculadas pela comparação dos conteúdos da tree
referenciada por esse commit com as trees associdadas com o seu parent.
De forma particular, o git não dá atenção para arquivos renomeados 
explicitamente, embora possa identificar casos onde a existência do mesmo 
conteúdo do arquivo na alteração sugira a renomeação. (Veja, por exemplo, a 
opção -M para linkgit:git-diff[1]).  

Um commit é normalmente criado por linkgit:git-commit[1], que cria um commit no 
qual o parent é normalmente o HEAD atual, e do qual a tree é levada do conteúdo
atualmente armazenado no index.

### O Modelo de Objeto ###

Então, agora o que vimos os 3 pricipais tipos de objetos (blob, tree e commit),
vamos dar uma rápida olhada em como eles todos se relacionam juntos.

Se tivéssemos um simples projeto com a seguinte estrutura de diretório:

    $>tree
    .
    |-- README
    `-- lib
        |-- inc
        |   `-- tricks.rb
        `-- mylib.rb

    2 directories, 3 files

E comitamos ele para um repositório Git, seria representado assim:

[fig:objects-example]

Você pode ver que temos criado um objeto **tree** para cada diretório 
(incluindo o root) e um objeto **blob** para cada arquivo. Então temos um 
objeto **commit** apontando para o root, então podemos rastreá-lo até o momento 
em que o nosso projeto se parecia quando foi commitado.