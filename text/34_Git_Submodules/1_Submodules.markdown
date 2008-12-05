## Submodules ##

Grandes projetos muitas vezes são compostos de pequenos módulos auto-contidos.
Por exemplo, uma árvore de código fonte de uma distribuição Linux embarcada
incluirá cada software na distribuição com algumas modificações locais; pode ser
que um player de filme precise ser construido em cima de uma específica e bem 
trabalhada versão de uma biblioteca de descompressão; diversos programas 
independentes podem compartilhar os mesmos scripts de construção.

Isso geralmente é característico em sistemas centralizados de controle de versão 
por incluir cada módulo em um simples repositório. Desenvolvedores podem
baixar todos os módulos ou somente os módulos que eles precisam trabalhar.
Eles podem até modificar arquivos pelos diversos módulos em um simples commit
enquanto move coisas ou atualiza APIs e traduções.

Git não permite checkouts parciais, então duplicando ele no Git, forçará aos
desenvolvedores manter uma cópia local dos módulos que eles não estão
interessados. Commits em grandes checkouts será mais lento do que você
poderia esperar com o Git, ele terá que buscar cada diretório por alterações.
Se os módulos possuem muito histórico local, clones levarão uma eternidade.

Por outro lado, sistemas de controle de revisão distribuida podem ser muito
melhor integrados com fontes externas. No modelo centralizado, uma simples cópia
arbitrária de um projeto externo é exportado de seu próprio controle de revisão e
então importado para o branch do controle de revisão local. Todo o histórico está 
escondido. Com controle de revisão distribuida você pode clonar o histórico 
externo inteiro, e muito mais facilmente seguir o desenvolvimento e realizar o 
re-merge das alterações locais.

O suporte a submodules no Git permite um repositório conter, como um
sub-diretório, uma cópia de um projeto externo. Submodules mantém sua própria
identidade; o suporte a submodule só armazena a localização do repositório do
submodule e a identificação do commit, então outros desenvolvedores que clonarem
o conteúdo do projeto ("superproject") podem facilmente clonar todos os submodules
na mesma revisão.
Checkouts parciais do superproject são possíveis: você pode chamar o Git para
clonar nenhum, alguns, ou todos os submodules.

O comando linkgit:git-submodule[1] está disponível desde o Git 1.5.3. Usuários com
Git 1.5.2 podem procurar os commits do submodule no repositório e manualmente
mover-se para eles; versões mais antigas não reconhecerão os submodules.

Para ver como o suporte a submodule funciona, crie (por exemplo) quatro repositórios
de exemplo que podem ser usados depois como submodule:

    $ mkdir ~/git
    $ cd ~/git
    $ for i in a b c d
    do
        mkdir $i
	    cd $i
	    git init
	    echo "module $i" > $i.txt
	    git add $i.txt
	    git commit -m "Initial commit, submodule $i"
	    cd ..
    done

Agora crie um superproject e adicione todos os submodules:    

    $ mkdir super
    $ cd super
    $ git init
    $ for i in a b c d
    do
        git submodule add ~/git/$i
    done

NOTA: Não use URLs locais aqui se você planeja publicar seu superproject!    

Veja que arquivos `git-submodule` criou:

    $ ls -a
    .  ..  .git  .gitmodules  a  b  c  d

O comando `git-submodule` faz várias coisas:


- Ele clona o submodule sobre o diretório atual e por padrão troca para o branch
  master.
- Ele adiciona o caminho do clone do submodule para o arquivo 
  linkgit:gitmodules[5] e adiciona esse arquivo no index, pronto para o commit.
- Ele adiciona a ID do commit atual do submodule no index, pronto para o commit.

Commit o superproject:

    $ git commit -m "Add submodules a, b, c and d."

Agora clone o superproject:    

    $ cd ..
    $ git clone super cloned
    $ cd cloned

Os diretórios do submodule existem, mas estão vazios:    

    $ ls -a a
    .  ..
    $ git submodule status
    -d266b9873ad50488163457f025db7cdd9683d88b a
    -e81d457da15309b4fef4249aba9b50187999670d b
    -c1536a972b9affea0f16e0680ba87332dc059146 c
    -d96249ff5d57de5de093e6baff9e0aafa5276a74 d

NOTA: Os nomes dos objetos commit mostrado acima serão diferentes para você, 
mas eles deverão corresponder aos nomes dos objetos commit do HEAD em seu 
repositório. Você pode verificar ele executando `git ls-remote ../a`.

Baixar os submodules é um processo de dois passos. Primeiro execute 
`git submodule init` para adicionar a URL do repositório submodule para 
`.git/config`:

    $ git submodule init

Agora use `git-submodule update` para clonar o repositório e verificar os 
commits especificados no superproject:    

    $ git submodule update
    $ cd a
    $ ls -a
    .  ..  .git  a.txt

Uma das maiores diferenças entre `git-submodule update` e `git-submodule add` é
que `git-submodule update` verifica um commit específico, ou melhor o branch atual. 
Isso é como mover-se para uma tag: o head é isolado, então você não trabalha
sobre o branch.

    $ git branch
    * (no branch)
    master

Se você quer fazer uma alteração dentro de um submodule e você tem um head isolado,
então você deverá criar ou mudar para um branch, fazer suas alterações, publicar a
alteração dentro do submodule, e então atualizar o superprojetct para referenciar 
o novo commit:

    $ git checkout master

ou

    $ git checkout -b fix-up

então:

    $ echo "adding a line again" >> a.txt
    $ git commit -a -m "Updated the submodule from within the superproject."
    $ git push
    $ cd ..
    $ git diff
    diff --git a/a b/a
    index d266b98..261dfac 160000
    --- a/a
    +++ b/a
    @@ -1 +1 @@
    -Subproject commit d266b9873ad50488163457f025db7cdd9683d88b
    +Subproject commit 261dfac35cb99d380eb966e102c1197139f7fa24
    $ git add a
    $ git commit -m "Updated submodule a."
    $ git push

Você tem que executar `git submodule update` depois `git pull` se você também 
quer atualizar os submodules.      

###Armadilhas com submodules

Sempre publique a alteração do submodule antes de publicar as alterações para o
superproject que referencia ele. Se você esquecer de publicar as alterações do
submodule, outros não serão capazer de clonar o repositório.

    $ cd ~/git/super/a
    $ echo i added another line to this file >> a.txt
    $ git commit -a -m "doing it wrong this time"
    $ cd ..
    $ git add a
    $ git commit -m "Updated submodule a again."
    $ git push
    $ cd ~/git/cloned
    $ git pull
    $ git submodule update
    error: pathspec '261dfac35cb99d380eb966e102c1197139f7fa24' did not match any file(s) known to git.
    Did you forget to 'git add'?
    Unable to checkout '261dfac35cb99d380eb966e102c1197139f7fa24' in submodule path 'a'

Você também não deveria voltar branches em um submodule além de commits que sempre 
foram gravados em algum superproject.

Não é seguro executar `git submodule update` se você tem feito e commitado
alterações dentro do submodule sem verificar o branch primeiro. Eles serão
sobrescritos silenciosamente:

    $ cat a.txt
    module a
    $ echo line added from private2 >> a.txt
    $ git commit -a -m "line added inside private2"
    $ cd ..
    $ git submodule update
    Submodule path 'a': checked out 'd266b9873ad50488163457f025db7cdd9683d88b'
    $ cd a
    $ cat a.txt
    module a

NOTA: As alterações ainda são visíveis no reflog dos submodules.    

Isso não é o caso se você não realizou o commit de suas alterações.

[gitcast:c11-git-submodules]("GitCast #11: Git Submodules")
