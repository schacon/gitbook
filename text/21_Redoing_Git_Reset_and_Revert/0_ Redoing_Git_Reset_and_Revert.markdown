## Desfazendo no Git - Reset, Checkout e Revert ##

Git provê múltiplos métodos para corrigir erros quando você está desenvolvendo.
Selecionar um método apropriado depende se possui ou não erros commitados, e 
se você commitou os erros, se você compartilhou os commits com problemas com
alguém.

### Corrigindo erros não commitados ###

Se você cometeu erros na sua árvore de trabalho, mas ainda não commitou
esses erros, você pode retornar a árvore de trabalho inteira para o último
estado commitado com:

    $ git reset --hard HEAD

Isso descartará qualquer alteração que você possa ter adicionado no index do
git e assim como qualquer alteração que você tenha na sua árvore de trabalho.
Em outras palavras, isso causa no resultado de "git diff" e "git diff 
--cached" que sejam ambos vazios.

Se você quer restaurar só um arquivo, digamos seu hello.rb, use
linkgit:git-checkout[1]:

    $ git checkout -- hello.rb
    $ git checkout HEAD hello.rb

O primeiro comando restaura hello.rb para a versão no index, para que
o "git diff hello.rb" retorne nenhuma direfença. O segundo comando
irá restaurar hello.rb da versão no HEAD, para que ambos 
"git diff hello.rb" e "git diff --cached hello.rb" retornem nenhuma diferença. 


### Corrigindo erros commitados ###

Se você realizou um commit que não queria, existem dois caminhos 
fundamentalmente diferentes para resolver o problema:

1. Você pode criar um novo commit que desfaz qualquer coisa que foi
    feita pelo commit antigo. Essa é a maneira correta se seu erro
    já se tornou público.

2. Você pode voltar e modificar o commit antigo. Você nunca deveria fazer
    isso se você já tornou o histórico público; git normalmente não espera
    que o "histórico" de um projeto mude, e não pode realizar corretamente
    merges repetidos de um branch que possue o histórico alterado.


#### Corrigindo um erro com um novo commit ####

Criando um novo commit que reverte um alteração mais recente é muito fácil;
só passar para o comando linkgit:git-revert[1] a referência para o commit ruim;
por exemplo, para reverter o commit mais recente:

    $ git revert HEAD

Isso criará um novo commit que desfaz as modificações no HEAD. Será dado a
você a oportunidade de editar a mensagem do commit para o novo commit.

Você pode também reverter uma alteração mais recente, por exemplo, o 
próximo-para-último:

    $ git revert HEAD^

Nesse caso o git entenderá para desfazer a alteração antiga enquanto mantém
intacto qualquer alteração feita desde então. Se alterações mais recentes 
sobreporem com as alterações para serem revertidas, então você será questionado
para corrigir manualmente os conflitos, bem na hora da resolução do merge.


#### Corrigindo um erro pela modificação de um commit ####

Se você já commitou algo mas percebe que você precisa consertá-lo, versões
recentes do linkgit:git-commit[1] suporta uma flag **--amend** que instrui
o git para substituir o commit HEAD com um novo, baseado no conteúdo atual do
index. Isso dá a você uma oportunidade para adicionar arquivos que você 
esqueceu de adicionar ou corrigir a mensagem do commit, antes de enviar as 
alterações para o mundo ver.

Se você encontrar um erro em um commit antigo, mas ainda um dos que você ainda
não publicou para o mundo, você pode usar linkgit:git-rebase[1] em modo 
interativo, com "git rebase -i" fazendo a alteração que requerem correção com 
**edit**. Isso permitirá a você juntar o commit durante o processo de rebase.