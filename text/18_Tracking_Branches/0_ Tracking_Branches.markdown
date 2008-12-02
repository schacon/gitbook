## Tracking Branches ##

Um 'tracking branch' no Git é um branch local que é conectado a um branch 
remoto. Quando você realiza um push e pull nesse branch, ele automaticamente
envia e recupera do branch remoto com quem está conectado.

Use ele se você sempre realiza um pull de um mesmo branch dentro de um novo
, e se você não quer usar "git pull <repository> <refspec>"  explicitamente.

O comando 'git clone' automaticamente configura um branch 'master' que é um
branch associado com 'origin/master' - o branch master sobre um repositório 
clonado.

Você pode criar um tracking branch manualmente pela adição da opção '--track'
sobre o comando branch no Git.

	git branch --track experimental origin/experimental

Então quando você executar:    

	$ git pull experimental

Ele irá automaticamente recuperar do 'origin' e realizará um merge de
'origin/experimental' dentro de seu branch local 'experimental'.

Dessa forma, quando você realizar um push para o origin, ele enviará para o 
qual seu 'experimental' aponta, sem ter que especificá-lo.