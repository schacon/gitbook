## Referências Git  ##

Branches, remote-tracking branches, e tags são todos referências para
commits. Todas as referências são nomeadas, com o nome do caminho
separado por barra "/" iniciando com "refs"; os nomes que usávamos até
agora são na verdade atalhos:

	- O branch "test" é abreviado de "refs/heads/test".
	- A tag "v2.6.18" é abreviado de "refs/tags/v2.6.18".
	- "origin/master" é abreviado de "refs/remotes/origin/master".

O nome completo é ocasionalmente útil se, por exemplo, se existe uma tag
e um branch com o mesmo nome.

(refs recém criadas são na verdade armazenadas no diretório .git/refs,
sobre o caminho formado pelo seu nome. Contudo, por razões de eficiência eles
podem também ser empacotados juntos em um simples arquivo; veja 
linkgit:git-pack-refs[1]).

Um outro atalho útil, o "HEAD" de um repositório pode ser referenciado para
usar somente o nome daquele repositório. Então, por exemplo, "origin" é 
normalmente um atalho para o branch HEAD no repositório "origin".

Para completar a lista de caminhos que o git verifica pelas referências, e
a ordem que ele usa para decidir qual escolher quando existem múltiplas
referências com o mesmo atalho, veja a seção "SPECIFYING
REVISIONS" do linkgit:git-rev-parse[1]. 


### Mostrando commits únicos de um dado branch ###

Suponha que você gostaria de ver todos os commits alcançáveis do branch head
chamado "master" mas não de qualquer outro head no seu repositório.

Podemos listar todos os heads nesse repositório com linkgit:git-show-ref[1]:

    $ git show-ref --heads
    bf62196b5e363d73353a9dcf094c59595f3153b7 refs/heads/core-tutorial
    db768d5504c1bb46f63ee9d6e1772bd047e05bf9 refs/heads/maint
    a07157ac624b2524a059a3414e99f6f44bebc1e7 refs/heads/master
    24dbc180ea14dc1aebe09f14c8ecf32010690627 refs/heads/tutorial-2
    1e87486ae06626c2f31eaa63d26fc0fd646c8af2 refs/heads/tutorial-fixes

Podemos conseguir só os nomes do branch, e remover "master", com a ajuda dos
utilitários padrões cut e grep:

    $ git show-ref --heads | cut -d' ' -f2 | grep -v '^refs/heads/master'
    refs/heads/core-tutorial
    refs/heads/maint
    refs/heads/tutorial-2
    refs/heads/tutorial-fixes

E então podemos ver todos os commits alcaçáveis do master mas não desse outros 
heads:    

    $ gitk master --not $( git show-ref --heads | cut -d' ' -f2 |
    				grep -v '^refs/heads/master' )

Obviamente, intermináveis variações são possíveis; por exemplo, para ver todos
os commits alcançáveis de algum head mas não de qualquer tag no repositório:                    

    $ gitk $( git show-ref --heads ) --not  $( git show-ref --tags )

(Veja linkgit:git-rev-parse[1] para explicações da sintaxe de commit-selecting
como por exemplo `--not`.)

(!!update-ref!!)
