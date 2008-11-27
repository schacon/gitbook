## Básico sobre Branching e Merging ##

Um simples repositório git pode manter múltiplos branches de
desenvolvimento. Para criar um novo branch chamado "experimental",
use :

    $ git branch experimental

Se executar agora

    $ git branch

você terá uma lista de todos os branches existentes:
    
      experimental
    * master

O branch "experimental" é o que você criou, e o branch "master" é um 
padrão, que foi criado automaticamente. O asterisco marca o branch
no qual você está atualmente.
Digite

    $ git checkout experimental

para trocar para o branch experimental. Agora edite um arquivo, realize o 
commit da alteração e volte para o branch master:

    (edit file)
    $ git commit -a
    $ git checkout master

Verifique que a alteração que você fez não está mais visível, que foi feito 
sobre o branch experimental e agora que você está de volta sobre o branch 
master.

Você pode fazer uma alteração diferente sobre o branch master:

    (edite um arquivo)
    $ git commit -a

nesse ponto os dois branches tem divergências, com diferentes modificações em 
cada um. Para realizar um merge das alterações feitas no branch experimental 
para o master, execute

    $ git merge experimental

Se as mudanças não conflitarem, você terminou aqui. Se existem conflitos,
marcas serão deixadas nos arquivos problemáticos monstrando os conflitos;

    $ git diff

irá mostrá-los. Um vez que você editou os arquivos para resolver os conflitos    

    $ git commit -a

irá realizar o commit do resultado do merge. Finalmente

    $ gitk

mostrará um belo gráfico da representação resultante do histórico.

Nesse ponto você poderá apagar o branch experimental com

    $ git branch -d experimental

Esse comando assegura que as alterações no branch experimental já estão no 
no branch atual.

Se você desenvolve sobre o um brach crazy-idea, então se arrependeu, você 
sempre pode apagar o branch com

    $ git branch -D crazy-idea

Branches são baratos e fáceis, então é uma boa maneira para testar alguma coisa.

### Como realizar um merge ###

Você pode reunir dois diferentes branches de desenvolvimento usando 
linkgit:git-merge[1]:

    $ git merge branchname

realiza um merge com as alterações feitas no branch "branchname" no branch 
atual. Se existirem conflitos -- por exemplo, se o mesmo arquivo é modificado
em duas diferentes formas no branch remoto e o branch local -- então você será
avisado; a saída pode parecer alguma coisa com isso:

    $ git merge next
     100% (4/4) done
    Auto-merged file.txt
    CONFLICT (content): Merge conflict in file.txt
    Automatic merge failed; fix conflicts and then commit the result.

Marcadores dos conflitos são deixados nos arquivos problemáticos, e depois que
você resolve os conflitos manualmente, você pode atualizar o index com o 
conteúdo e executar o git commit, como você faria normalmente quando modifica 
um arquivo.

Se você examinar o resultado do commit usando o gitk, você verá que ele
possue dois pais: um apontando para o topo do branch atual, e um para topo
do outro branch.

### Resolvendo um merge ###

Quando um merge não é resolvido automaticamente, o git deixa o index e a
árvore de trabalho em um estado especial que fornece a você todas as 
informações que você precisa para ajudar a resolver o merge.

Arquivos com conflitos são marcados especialmente no index, então até 
você resolver o problema e atualizar o index, o comando linkgit:git-commit[1] 
irá falhar.

    $ git commit
    file.txt: needs merge

Também, linkgit:git-status[1] listará esses arquivos como "unmerged", e os 
arquivos com conflitos terão os conflitos adicionados, assim:

    <<<<<<< HEAD:file.txt
    Hello world
    =======
    Goodbye
    >>>>>>> 77976da35a11db4580b80ae27e8d65caf5208086:file.txt

Tudo que você precisa fazer é editar os arquivos para resolver os conflitos,
e então

    $ git add file.txt
    $ git commit

Veja que a mensagem de commit já estará preenchida nele para você com
algumas informações sobre o merge. Normalmente você pode usá-la sem mudança 
nessa mensagem padrão, mas você pode adicionar um comentario adicional se
desejado.

Tudo acima é o que você precisa saber para resolver um simples merge. Mas o git
também provê mais informações para ajudar a resolver os conflitos:

### Desfazendo um merge ###

Se você ficar preso e decide desistir e jogar toda a bagunça fora, você pode 
sempre retornar ao estado do pre-merge com

    $ git reset --hard HEAD

Ou, se você já estiver realizado o commit do merge que você quer jogar fora,

    $ git reset --hard ORIG_HEAD

Contudo, esse último comando pode ser perigoso em alguns casos -- nunca jogue
fora um commit se esse commit já pode ter sido realizado um merge em outro 
branch, que pode confundir novos merges.

### Merges Fast-forward ###

Existe um caso especial não mencionado acima, que é tratado diferentemente.
Normalmente, um merge resulta em um commit com dois pais, um de cada uma das
duas linhas de desenvolvimento que foram realizados o merge.

Contudo, se o branch atual não tem divergência do outro -- então cada commit 
presente no branch atual já está contido no outro -- então o git só realiza um
"fast foward"; o HEAD do branch atual é movido para o ponto do HEAD do branch 
que realiza o merge, sem que qualquer novo commit seja criado.


[gitcast:c6-branch-merge]("GitCast #6: Branching e Merging")
