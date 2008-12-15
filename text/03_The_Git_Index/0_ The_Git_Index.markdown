## O Index do Git ##

O index do Git é usado como uma área de preparação entre o seu diretório de
trabalho e o seu repositório. Você pode usar o index para contruir um conjunto
de modificações no qual você quer levar juntos para o próximo commit. Quando
você cria um commit, o que é commitado é o que está no index atualmente, não o
que está no seu diretório de trabalho.

### Visualizando o Index ###

A forma mais fácil para ver o que está no index é com o comando
linkgit:git-status[1]. Quando você roda o git status, você pode ver quais
arquivos estão selecionados para o próximo commit (atualmente no seu index),
quais estão modificados mas não ainda não foram selecionados, e quais estão
completamente sem nenhuma seleção.

    $>git status
    # On branch master
    # Your branch is behind 'origin/master' by 11 commits, and can be fast-forwarded.
    #
    # Changes to be committed:
    #   (use "git reset HEAD <file>..." to unstage)
    #
    #	modified:   daemon.c
    #
    # Changed but not updated:
    #   (use "git add <file>..." to update what will be committed)
    #
    #	modified:   grep.c
    #	modified:   grep.h
    #
    # Untracked files:
    #   (use "git add <file>..." to include in what will be committed)
    #
    #	blametree
    #	blametree-init
    #	git-gui/git-citool

Se você descartar o index completamente, você em geral não perde qualquer
informação contanto que você tenha o nome da tree que ele descreveu.

E com isso, você deveria ter um bom entendimento das coisas básicas que o Git
faz por traz da cena, e porque ele é um pouco diferente da maioria dos outros
sistemas SCM. Não se preocupe se você não entendeu completamente tudo até
agora; iremos revisar todos esses tópicos nas próximas seções. Agora estamos
prontos para irmos a instalação, configuração e uso do Git.