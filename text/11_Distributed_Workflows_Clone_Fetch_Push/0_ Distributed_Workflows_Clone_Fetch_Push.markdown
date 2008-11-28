## Fluxo de Trabalho Distribuido ##

Suponha que Alice tenha iniciado um novo projeto com um repositório git em
/home/alice/project, e que Bob, que possui um diretório home na mesma máquina,
quer contribuir.

Bob inicia com:

    $ git clone /home/alice/project myrepo

Isso cria um novo diretório "myrepo" contendo um clone do repositório de Alice
O clone está na mesma condição de igualdade do projeto original, possuindo sua 
própria cópia do histórico do projeto original.

Bob então faz algumas alterações e commits dele:


    (edite alguns arquivos)
    $ git commit -a
    (repita quando necessário)

Quando terminar, ele comunica a Alice para realizar um pull das alterações do 
repositório em /home/bob/myrepo. Ela faz isso com:

    $ cd /home/alice/project
    $ git pull /home/bob/myrepo master

Isso realiza um merge com as alterações do branch master de Bob para o branch 
atual de Alice. Enquanto isso se Alice tem feito suas próprias modificações,
então ela pode precisar corrigir manualmente quaisquer conflitos. (Veja que o
argumento "master" no comando acima é na verdade desnecessário, já que ele é o 
padrão).

O comando "pull" realiza assim duas operações: ele recebe as alterações mais 
recentes do branch remoto, então realiza um merge dele no branch atual.

Quando você está trabalhando em um pequeno grupo muito unido, não é incomum
interagir com o mesmo repositório e outro novamente. Definindo  um 
repositório como 'remote', você pode fazer isso facilmente:

    $ git remote add bob /home/bob/myrepo

Com isso, Alice pode realizar a primeira operação sozinha usando o comando 
"git fetch" sem realizar um merge dele com o seu próprio branch, usando:

    $ git fetch bob

Ao contrário da forma longa, quando Alice recebe as novas alterações usando um
repositório remoto configurado com 'git remote', que foi recuperado e 
armazenado em um branch remoto, nesse caso 'bob/master'. Então depois disso:

    $ git log -p master..bob/master

mostra uma lista de todas as alterações que Bob fez desde quando ele criou o
branch master de Alice.

Depois de examinar essas alterações, Alice poderá realizar um merge com as 
alterações dentro de seu branch master:

    $ git merge bob/master

Esse 'merge' também pode ser feito 'realizando um pull a partir de seu próprio 
branch remoto registrado', dessa forma:

    $ git pull . remotes/bob/master

Perceba que o git pull sempre realiza o merge dentro de seu branch atual,
sem levar em conta o que é dado na linha de comando.

Por fim, Bob pode atualizar seu repositório com as últimas alterações de Alice
usando:

    $ git pull

Veja que não foi preciso dar o caminho para o repositório de Alice;
quando Bob clonou o repositório de Alice, o git armazenou a localização do 
repositório dela nas configurações de seu repositório, e essa localização é 
usada pelo pull:

    $ git config --get remote.origin.url
    /home/alice/project

(A configuração completa criada por git-clone é visível usando 
"git config -l"), e a página do manual linkgit:git-config[1] explica o
significado de cada opção.

Git também deixa uma cópia original do branch master de Alice sobre o nome de
"origin/master":

    $ git branch -r
      origin/master

Se Bob decide trabalhar a partir de um host diferente, ele ainda pode realizar
clones e pulls usando o protocolo ssh: 

    $ git clone alice.org:/home/alice/project myrepo

Alternativamente, git possui um protocolo nativo, ou pode usar rsync or http;
veja linkgit:git-pull[1] para mais detalhes.   

Git também pode ser usado no modo CVS, com um repositório central para onde 
vários usuários enviam alterações; veja linkgit:git-push[1] e 
link:cvs-migration.html[git para usuários CVS].


### Repositórios Git Públicos ###

Uma outra forma de enviar alterações para um projeto é informar ao responsável 
por aquele projeto para realizar um pull das alterações de seu repositório 
usando linkgit:git-pull[1]. Na seção "<<getting-updates-with-git-pull,
Recuperando alterações com git-pull>>" nós descrevemos uma forma de
recuperar do repositório "principal", mas ele também funciona em outras 
direções.

Se o responsável pelo projeto e você possuem contas na mesma máquina, então
você pode somente realizar um pull das alterações diretamente do outro 
repositório; comandos que aceitam URLs de repositórios como argumentos também
aceitam nomes de diretórios locais:

    $ git clone /caminho/para/repositorio
    $ git pull /caminho/para/outro/repositorio

ou uma URL ssh:

    $ git clone ssh://suamaquina/~voce/repositorio

Para projetos com alguns desenvolvedores, ou para a sincronização de alguns 
repositórios privados, isso pode ser tudo que você precisa.   

Contudo, a forma mais comum de fazer isso é manter um repositório público 
separado (na verdade em uma máquina diferente) para os outros realizarem pull
das alterações. Isso é na verdade mais conveniente, e permite claramente a você
separar trabalho pessoal em progresso do trabalho visível publicamente.

Você continuará a fazer seu trabalho diário em seu repositório pessoal, mas 
periódicamente realiza um "push" das alterações de seu repositório pessoal
para o seu repositório público, permitindo os outros desenvolvedores realizar 
pulls daquele repositório. Então o fluxo de alterações, na situação onde existe
um outro desenvolvedor com repositório público, parece com isso:

                         você realiza push
      seu repo pessoal --------------------> seu repo público
    	^                                     |
    	|                                     |
    	| você realiza pull                   | eles realizam pull
    	|                                     |
    	|                                     |
        |                 eles realizam push  V
      repo público deles <------------------ repo pessoal deles
      


### Enviando alterações para um repositório público ###

Veja que as duas técnicas desenhadas acima ( exportando através
<<exporting-via-http,http>> ou <<exporting-via-git,git>>) permite outros
responsáveis por projetos receberem as últimas alterações sua, mas eles não
tem permissão de escrita, no qual você precisará atualizar o repositório 
público com as últimas alterações criadas no seu repositório pessoal.

Uma forma simples de fazer isso é usando linkgit:git-push[1] e ssh; para
atualizar o branch remoto chamado "master" com o último estado de seu branch
chamado "master", execute

    $ git push ssh://seuservidor.com/~voce/proj.git master:master

ou só

    $ git push ssh://seuservidor.com/~voce/proj.git master

Como o git-fetch, git-push irá reclamar se isso não resultar em um    
<<fast-forwards,fast forward>>; veja a seção sequinte sobre como proceder
nesse caso.

Veja que o alvo do "push" é normalmente um repositório  <<def_bare_repository,bare>>. 
Você também pode enviar para um repositório que tem a árvore de trabalho 
atualizada, mas essa árvore não será atualizada pelo push. Isso pode levar a
resultados inesperados se o branch que você enviou é o branch atual.

Como com o git-fetch, você também pode ajustar as opções de configuração, 
então por exemplo, depois

    $ cat >>.git/config <<EOF
    [remote "public-repo"]
    	url = ssh://seuservidor.com/~voce/proj.git
    EOF

você deverá estar capaz de realizar o push acima só com    

    $ git push public-repo master

Veja as explicações das opções remote.<name>.url, branch.<name>.remote,     
e remote.<name>.push em linkgit:git-config[1] para mais detalhes.


### O que fazer quando um push falha ###

Se um push não resultar em um <<fast-forwards,fast forward>> do branch remoto
então falhará com um erro desse tipo:

    error: remote 'refs/heads/master' is not an ancestor of
    local  'refs/heads/master'.
    Maybe you are not up-to-date and need to pull first?
    error: failed to push to 'ssh://seuservidor.com/~voce/proj.git'

Isso pode acontecer, por exemplo, se você    

	- usar 'git-reset --hard' para remover commit já publicados, ou
	- usar 'git-commit --amend' para substituir commits já publicados
	  (como em <<fixing-a-mistake-by-rewriting-history>>), or
	- usar 'git-rebase' para recriar qualquer commit já publicado (como
	  em <<using-git-rebase>>).

Você pode forçar git-push para realizar a atualização precedendo o nome do
branch com um sinal de +:      

    $ git push ssh://seuservidor.com/~voce/proj.git +master

Normalmente quando um brach head é modificado em um repositório público, ele
é modificado para apontar para um descendente desse commit que ele apontou antes.
Forçar um push nessa situação, você quebra aquela convênção.
(Veja <<problems-with-rewriting-history>>.)

Contudo, essa é uma prática comum para pessoas que precisam de uma forma 
simples para publicar uma série de patch de um trabalho em progresso, e é um
compromisso aceitável contanto que você avise os outros desenvolvedores que é 
dessa forma que pretende gerenciar o branch.

Desta forma também é possível para um push falhar quando outras pessoas tem o 
direito de enviar para o mesmo repositório. Nesse caso, a solução correta para 
tentar re-enviar depois da primeira atualização de seu trabalho: qualquer um 
pull, ou um fetch seguido por um rebase; veja o 
<<setting-up-a-shared-repository,next section>> e
linkgit:gitcvs-migration[7] para mais informações.

[gitcast:c8-dist-workflow]("GitCast #8: Fluxo de Trabalho Distribuido")
