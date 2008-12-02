## Stashing ##

Enquanto você está trabalhando no meio de algo complicado, você encontra 
um erro não documentado mas óbvio e trivial. Você gostaria de corrigir ele
antes de continuar. Você pode usar linkgit:git-stash[1] para gravar o estado
atual de seu trabalho, e depois corrigir o erro (ou, opcionalmente depois de
fazê-lo sobre um branch diferente e então voltar), e recuperar as alterações 
que estava trabalhando antes do erro.

    $ git stash "work in progress for foo feature"

Esse comando gravará suas alterações para o `stash` e resetará sua árvore de
trabalho e o index para o início de seu branch atual. Você então pode fazer
as correções como de costume.

    ... edite e teste ...
    $ git commit -a -m "blorpl: typofix"

Depois disso, você pode voltar para aquilo que estava trabalhando usando 
`git stash apply`:    

    $ git stash apply


### Fila de Stash ###

Você também pode usar o stash para enfileirar stashes.
Se você executar 'git stash list' você pode ver que staches você tem salvo:

	$>git stash list
	stash@{0}: WIP on book: 51bea1d... fixed images
	stash@{1}: WIP on master: 9705ae6... changed the browse code to the official repo

Então você pode aplicar eles individualmente com 'git stash apply stash@{1}'. 
Você pode limpar a lista com 'git stash clear'.