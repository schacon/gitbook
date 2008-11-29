## Rebasing ##

Suponha que você criou um branch "mywork" sobre um branch remoto "origin".

    $ git checkout -b mywork origin

[fig:rebase0]

Agora você faz algum trabalho, criando dois novos commits.

    $ vi file.txt
    $ git commit
    $ vi otherfile.txt
    $ git commit
    ...

Enquanto isso, alguém também faz algum trabalho criando dois novos commits 
sobre o branch origin.
Nisso ambos 'origin' e 'mywork' avançam seus trabalhos, existindo divergências 
entre eles.

[fig:rebase1]

Neste ponto, você poderia usar "pull" para juntar suas alterações de volta 
nele; o resultado criará um novo commit através do merge, como isso:

[fig:rebase2]

Contudo se você prefere manter o histórico em 'mywork', como uma simples série 
de commits sem qualquer merge, ao invés disso você pode escolher usar
linkgit:git-rebase[1]:

    $ git checkout mywork
    $ git rebase origin

Isso removerá cada um dos seus commits de 'mywork', temporariamente salvando
eles como patches (em um diretório chamado ".git/rebase"), atualizar 'mywork' para
apontar para a última versão de 'origin', então aplicar cada um dos patches salvos 
para o novo 'mywork'.

[fig:rebase3]

Uma vez que ('mywork') é atualizado para apontar para o mais novo objeto commit
criado, seus velhos commits serão abandonados. Eles provavelmente serão 
removidos se você executar a coleta de lixo. (see linkgit:git-gc[1])

[fig:rebase4]

Então agora podemos ver a diferença em nosso histórico entre um merge e um 
rebase executado:

[fig:rebase5]

No processo de rebase, ele pode descobrir alguns conflitos. Nesse caso ele 
interromperá e permitirá a você corrigir os conflitos; depois que corrigí-los,
use "git-add" para atualizar o index com esse conteúdo, e então, ao invés de
executar git-commit, só execute

    $ git rebase --continue

e o git continuará aplicando o resto dos patches.

Em qualquer ponto você pode usar a opção '--abort'  para esse processo e
retornar 'mywork' para o estado que tinha antes de você iniciar o rebase:

    $ git rebase --abort


[gitcast:c7-rebase]("GitCast #7: Rebasing")