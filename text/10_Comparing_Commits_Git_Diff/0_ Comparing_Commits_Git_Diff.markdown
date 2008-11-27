## Comparando Commits - Git Diff ##

Você pode gerar diffs entre duas versões quaisquer do seu projeto usando
linkgit:git-diff[1]:

    $ git diff master..test

Isso produzirá o diff entre os dois branches. Se você preferir encontrar o diff
dos ancestrais comuns do test, você pode usar três pontos ao invés de dois.

    $ git diff master...test

linkgit:git-diff[1] é uma ferramenta incrivelmente útil para entender as 
alterações que exitem entre dois pontos quaisquer no histórico de seu projeto,
ou para ver o que as pessoas estão tentando introduzir em novos branches, etc.

### O que você irá commitar ###

Você usará normalmente linkgit:git-diff[1] para entender as diferenças entre
seu último commit, seu index, e seu diretório de trabalho.
Um uso comum é simplesmente executar
    
    $ git diff
    
que mostrará a você alterações no diretório de trabalho atual que ainda não foi
selecionado para o próximo commit.
Se você quer ver o que _está_ selecionado para o próximo commit, você pode 
executar

    $ git diff --cached

que mostrará a você as diferenças entre o index e o seu último commit;
o que estará sendo commitado se você executar "git commit" sem a opção
"-a".
Finalmente, você pode executar

    $ git diff HEAD

que mostra as alterações no diretório de trabalho atual desde seu último commit;
o que estará sendo commitado se você executrar "git commit -a".

### Mais opções Diff ###

Se você quer ver como seu diretório corrente difere do estado em outro branch
do projeto, você pode executar algo como:

    $ git diff test

Isso mostrará a você a direfença entre seu diretório de trabalho atual e o 
snapshot sobre o branch 'test'. Você também pode limitar a comparação para um
arquivo específico ou sub diretório pela adição do *path limiter*:

    $ git diff HEAD -- ./lib 

Esse comando mostrará as alterações entre seu diretório de trabalho atual e 
o último commit (ou, mais exatamente, dar uma dica sobre o branch atual), 
limitando a comparação para os arquivos no diretório 'lib'.

Se você não quer ver o patch inteiro, você pode adicionar a opção '--stat',
que limitará a saída para os arquivos que possui alteração junto com um 
pequeno gráfico em texto representando a quantidade de linhas alteradas 
em cada arquivo.

    $>git diff --stat
     layout/book_index_template.html                    |    8 ++-
     text/05_Installing_Git/0_Source.markdown           |   14 ++++++
     text/05_Installing_Git/1_Linux.markdown            |   17 +++++++
     text/05_Installing_Git/2_Mac_104.markdown          |   11 +++++
     text/05_Installing_Git/3_Mac_105.markdown          |    8 ++++
     text/05_Installing_Git/4_Windows.markdown          |    7 +++
     .../1_Getting_a_Git_Repo.markdown                  |    7 +++-
     .../0_ Comparing_Commits_Git_Diff.markdown         |   45 +++++++++++++++++++-
     .../0_ Hosting_Git_gitweb_repoorcz_github.markdown |    4 +-
     9 files changed, 115 insertions(+), 6 deletions(-)

As vezes fazer isso é mais fácil para visualizar tudo o que foi alterado, para 
refrescar sua memória.