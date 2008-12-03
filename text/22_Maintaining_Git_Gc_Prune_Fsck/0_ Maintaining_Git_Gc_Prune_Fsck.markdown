## Manutenção no Git ##

### Garantindo bom desempenho ###

Em grandes repositórios, git conta com a compressão para manter as informações 
do histórico que ocupam muito espaço no disco ou memória.

Essa compressão não é realizado automaticamente. Portanto você deveria
executar ocasionalmente linkgit:git-gc[1]:

    $ git gc

para recomprimir o arquivo. Isso pode consumir muito tempo, então você pode
preferir executar git-gc quando não estiver trabalhando.    


### Garantindo a confiabilidade ###

O comando linkgit:git-fsck[1] executa um número de verificações de consistência
sobre o repositório, e relata algum problema. Isso pode levar algum tempo.
De longe, o aviso mais comum é sobre objetos "dangling":

    $ git fsck
    dangling commit 7281251ddd2a61e38657c827739c57015671a6b3
    dangling commit 2706a059f258c6b245f298dc4ff2ccd30ec21a63
    dangling commit 13472b7c4b80851a1bc551779171dcb03655e9b5
    dangling blob 218761f9d90712d37a9c5e36f406f92202db07eb
    dangling commit bf093535a34a4d35731aa2bd90fe6b176302f14f
    dangling commit 8e4bec7f2ddaa268bef999853c25755452100f8e
    dangling tree d50bb86186bf27b681d25af89d3b5b68382e4085
    dangling tree b24c2473f1fd3d91352a624795be026d64c8841f
    ...
Objetos dangling não são problemas. No pior caso eles podem ocupar um pouco de
espaço extra. Eles algumas vezes podem prover um último método para recuperação
do trabalho perdido.