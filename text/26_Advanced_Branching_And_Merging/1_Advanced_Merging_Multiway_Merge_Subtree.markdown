### Merge Múltiplos ###

Você pode realizar um merge de diversos heads de uma vez só simplesmente 
listando eles sobre o mesmo comando linkgit:git-merge[1]. Por exemplo,

	$ git merge scott/master rick/master tom/master

é equivalente a :

	$ git merge scott/master
	$ git merge rick/master
	$ git merge tom/master

### Subtrees ###

Existem situações onde você quer incluir o conteúdo em seus projetos de um 
projeto desenvolvido independentemente. Você só realiza um pull do outro projeto
contanto que não existam conflitos nos caminhos. 

O caso problemátivo é quando existem arquivos conflitantes. Candidatos 
potênciais são Makefiles e outros nomes de arquivos padrões. Você poderia 
realizar um merge desses arquivos mas provavelmente você não vai querer fazê-lo.
Uma melhor solução para esse problema pode ser realizar um merge do projeto com
o seu próprio sub-diretório. Isso não é suportado pela estratégia de merges 
recursivos, então realizar pulls não funcionará.

O que você quer é a estratégia de subtrees do merge, que ajuda você nessa situação.

Nesse exemplo, digamos que você tem o repositório em /path/to/B (mas ele pode
ser uma URL, se quiser). Você quer realizar o merge do branch master daquele
repositório para o sub-diretório dir-B em seu branch atual.

Aqui está a sequencia do comando que você precisa:

	$ git remote add -f Bproject /path/to/B (1)
	$ git merge -s ours --no-commit Bproject/master (2)
	$ git read-tree --prefix=dir-B/ -u Bproject/master (3)
	$ git commit -m "Merge B project as our subdirectory" (4)
	$ git pull -s subtree Bproject master (5)
	

O benefício de usar subtree merges é que ele requer menos carga 
administrativa dos usuários de seu repositório. Isso funciona com clientes 
antigos (antes de Git v1.5.2) e tem o código correto depois do clone.

Contudo se você usa sub-módulos então você pode escolher não transferir os
objetos do sub-módulo. Isso pode ser um problema com subtree merges.

Também, nesse caso de você fazer alterações para outro projeto, é mais fácil para
enviar alterações se você só usa sub-módulos.

(de [Using Subtree Merge](http://www.kernel.org/pub/software/scm/git/docs/howto/using-merge-subtree.html))