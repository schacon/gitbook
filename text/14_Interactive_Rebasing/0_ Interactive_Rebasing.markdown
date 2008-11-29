## Rebasing Interativo ##

Você pode também realizar um rebase interativamente. Isso é usado muitas vezes
para re-escrever seus próprios objetos commit antes de enviá-los para algum 
lugar. Isso é uma forma fácil de dividir, juntar, ou re-ordenar os commits
antes de compartilhá-los com os outros. Você pode também usá-lo para limpar 
commits que você tenha baixado de alguém quando estiver aplicando ele 
localmente.

Se você tem um número de commits que você gostaria de alguma maneira modificar
durante o rebase, você pode invocar o modo interativo passando um '-i' ou 
'--interactive' para o comando 'git rebase'.

	$ git rebase -i origin/master

Isso invocará o modo de rebase interativo sobre todos os commits que você tem 
feito desde a última vez que você realizou um pull (ou merge de um repositório
origin).

Para ver de antemão quais são os commits, você pode executar dessa forma:
	
	$ git log origin/master..

Uma vez que você rodar o comando 'rebase -i', você será levado para o seu 
editor com algo parecido com isso:

	pick fc62e55 added file_size
	pick 9824bf4 fixed little thing
	pick 21d80a5 added number to log
	pick 76b9da6 added the apply command
	pick c264051 Revert "added file_size" - not implemented correctly

	# Rebase f408319..b04dc3d onto f408319
	#
	# Commands:
	#  p, pick = use commit
	#  e, edit = use commit, but stop for amending
	#  s, squash = use commit, but meld into previous commit
	#
	# If you remove a line here THAT COMMIT WILL BE LOST.
	# However, if you remove everything, the rebase will be aborted.
	#

Isso significa que existem 5 commits desde o último push realizado e lhe dará
uma linha por commit com o seguinte formato:

	(action) (partial-sha) (short commit message)

Agora, você pode alterar a ação (que é por padrão 'pick') para qualquer um 
'edit' ou 'squash', ou deixá-lo como 'pick'. Você também pode re-ordenar os
commits movendo as linhas como você quiser. Então, quando você sair do editor,
o git tentará aplicar os commits como eles estão organizados agora e realizar a
ação especificada.

Se 'pick' é especificado, ele simplesmente tentará aplicar o patch e salvar o
commit com a mesma mensagem de antes.

Se 'squash' é especificado, ele combinará aquele commit com um anterior para 
criar um novo commit. Você cairá novamente em seu editor para juntar as 
mensagens de commit dos dois commits que agora são combinados. Então, se você
sair do editor com isso:

	pick   fc62e55 added file_size
	squash 9824bf4 fixed little thing
	squash 21d80a5 added number to log
	squash 76b9da6 added the apply command
	squash c264051 Revert "added file_size" - not implemented correctly

Então você terá que criar uma única mensagem de commit dele:

	# This is a combination of 5 commits.
	# The first commit's message is:
	added file_size

	# This is the 2nd commit message:

	fixed little thing

	# This is the 3rd commit message:

	added number to log

	# This is the 4th commit message:

	added the apply command

	# This is the 5th commit message:

	Revert "added file_size" - not implemented correctly

	This reverts commit fc62e5543b195f18391886b9f663d5a7eca38e84.

Uma vez que você tem editado a mensagem de commit e sair do editor,
o commit será salvo com a sua nova mensagem.    

Se 'edit' é especificado, fará a mesma coisa, mas desde então para antes
de mover para o próximo commit e o levará para a linha de comando para você 
poder corrigir o commit, ou modificar o conteúdo do commit de alguma forma.

Se você queria dividir um commit, por exemplo, você especificaria 'edit' para
esse commit:

	pick   fc62e55 added file_size
	pick   9824bf4 fixed little thing
	edit   21d80a5 added number to log
	pick   76b9da6 added the apply command
	pick   c264051 Revert "added file_size" - not implemented correctly

E então quando você for levado para a linha de comando, você reverterá aquele 
commit em dois (ou mais) novos. Digamos que o 21d80a5 modificou dois arquivos, 
arquivo1 e arquivo2, e você queria dividir eles em commits separados. Você 
poderia fazer isso depois que o rebase deixá-lo na linha de comando:

	$ git reset HEAD^
	$ git add file1
	$ git commit 'first part of split commit'
	$ git add file2
	$ git commit 'second part of split commit'
	$ git rebase --continue

E agora ao invés dos 5 commits, você terá 6.	

A última coisa útil que o modo interativo do rebase pode fazer é retirar 
commits para você. Se ao invés de escolher 'pick', 'squash' ou 'edit' para a
linha do commit, você simplesmente remove a linha e isso removerá o commit do 
histórico.