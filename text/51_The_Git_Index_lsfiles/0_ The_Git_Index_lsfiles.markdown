## O Index do Git ##

O index é um arquivo binário (geralmente mantido em .git/index) contém uma
lista ordenada de caminhos, cada um com permissões e o SHA1 de um objeto 
blob; linkgit:git-ls-files[1] pode mostrar a você o conteúdo do index:

    $ git ls-files --stage
    100644 63c918c667fa005ff12ad89437f2fdc80926e21c 0	.gitignore
    100644 5529b198e8d14decbe4ad99db3f7fb632de0439d 0	.mailmap
    100644 6ff87c4664981e4397625791c8ea3bbb5f2279a3 0	COPYING
    100644 a37b2152bd26be2c2289e1f57a292534a51a93c7 0	Documentation/.gitignore
    100644 fbefe9a45b00a54b58d94d06eca48b03d40a50e0 0	Documentation/Makefile
    ...
    100644 2511aef8d89ab52be5ec6a5e46236b4b6bcd07ea 0	xdiff/xtypes.h
    100644 2ade97b2574a9f77e7ae4002a4e07a6a38e46d07 0	xdiff/xutils.c
    100644 d5de8292e05e7c36c4b68857c1cf9855e3d2f70a 0	xdiff/xutils.h

Veja que em uma documentação mais antiga você pode ver o index ser chamado de
"cache do diretório atual" ou só "cache". Ele possui três propriedades 
importantes:

1. O index contém todas as informações necessárias para gerar um simples
    (unicamente determinado) objeto tree.

    Por exemplo, executando linkgit:git-commit[1] gera esse objeto tree do
    index, armazena ele no banco de dados de objetos, e usa ele como o objeto
    tree associado com o novo commit.

2. O index habilita rápidas comparações entre o objeto tree e a árvore de 
    trabalho.

    Ele faz isso através do armazenamento de algum dado adicional para cada
    entrada (por exemplo a última hora modificada). Esse dado não é mostrado
    acima, e não está armazenado no objeto tree criado, mas ele pode ser usado
    para determinar rapidamente quais arquivos no diretório de trabalho diferem
    de qual foi armazenado no index, e dessa maneira economizar o git de ter
    que ler todos os dados de cada arquivo em busca de alterações.

3. Ele pode eficientemente representar informações sobre os conflitos de merge
    entre diferentes objetos tree, permitindo cada caminho ser associado
    com informação suficiente sobre as trees envolvidas que você pode criar um 
    merge de três-passos entre eles.

    Nós vimos na <<conflict-resolution>> que durante um merge o index pode 
    armazenar múltiplas versões de um simples arquivo (chamados de "estágios").
    A terceira coluna na saída do linkgit:git-ls-files[1] acima é o número do 
    estágio, e  aceitará valores exceto 0 para arquivo com conflidos de merge.

O index é dessa maneira uma área ordenada de estágios temporários, que é
preenchido com uma tree no qual você está, no processo de trabalho.
