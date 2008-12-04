## Procurando Erros - Git Bisect ##

Suponha uma versão 2.6.18 de seu projeto, mas a versão no "master" está defeituosa.
As vezes a melhor forma de encotrar a causa é realizar uma busca usando
força-bruta no histórico do projeto para encontrar o commit em particular que
causou o problema. O comando linkgit:git-bisect[1] pode ajudar você a fazer isso:

    $ git bisect start
    $ git bisect good v2.6.18
    $ git bisect bad master
    Bisecting: 3537 revisions left to test after this
    [65934a9a028b88e83e2b0f8b36618fe503349f8e] BLOCK: Make USB storage depend on SCSI rather than selecting it [try #6]

Se você executar "git branch" neste momento, você verá que o git moveu você
temporariamente para um novo branch chamado "bisect". Esse branch aponta para 
um commit (o commit 65934...) que está próximo do "master" mas não do v2.6.18.
Compile e teste-o, e veja se possui erro. Assumindo que ele possui erro. 
Então:

    $ git bisect bad
    Bisecting: 1769 revisions left to test after this
    [7eff82c8b1511017ae605f0c99ac275a7e21b867] i2c-core: Drop useless bitmaskings

vai para uma versão mais antiga. Continua assim, chamando o git em cada estágio
se a versão dele dá a você que é bom ou ruim, e avisa que o número de revisões 
restante para testar é cortado aproximadamente no meio em cada vez.
    
Depois de 13 testes (nesse caso), ele mostrará o id do commit culpado. Você pode 
então examinar o commit com linkgit:git-show[1], encontrar quem escreveu ele, e 
enviar um email a ele sobre esse bug com o id do commit. Finalmente , execute

    $ git bisect reset

para retorna ao branch onde estava antes e apagar o branch temporário "bisect".

Veja que a versão que git-bisect verifica para você em cada ponto é só uma 
sugestão, você está livre para tentar uma versão diferente se achar que isso
é uma boa idéia. Por exemplo, ocasionalmente você pode cair em um commit que 
possue um erro não registrado; execute

    $ git bisect visualize

que executará um gitk e marcar o commit escolhido com "bisect". Escolha um commit
seguro mais próximo, veja seu id, e mova-se até ele com:

    $ git reset --hard fb47ddb2db...

então teste, execute "bisect good" ou "bisect bad" de acordo, e continue.