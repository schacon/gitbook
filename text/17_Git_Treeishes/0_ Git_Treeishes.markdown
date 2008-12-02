## Git Treeishes ##

Existem inúmeros caminhos para referenciar um commit ou tree particular do que
"cuspir" o SHA de 40 dígitos inteiro. No Git, eles são conhecidos como um 
'treeish'.

### SHA Parcial ###

Se o SHA de seu commit é '<code>980e3ccdaac54a0d4de358f3fe5d718027d96aae</code>',
o git reconhecerá qualquer um desses igualmente: 

	980e3ccdaac54a0d4de358f3fe5d718027d96aae
	980e3ccdaac54a0d4
	980e3cc

Contanto que o SHA parcial seja único - ele não pode ser confundido com outro
( que é inacreditávelmente improvável se você usa pelo menos 5 caracteres), git
expandirá o SHA parcial para você.
   

### Branch, Remote ou Tag ###

Você sempre pode usar um branch, remote ou tag ao invés de um SHA, desde que 
eles sejam de alguma forma ponteiros. Se o seu branch master é o commit 
980e3 e você enviou ele para o origin(remoto) e nomeado com tag 'v1.0', então
todos os seguintes são equivalentes:

	980e3ccdaac54a0d4de358f3fe5d718027d96aae
	origin/master
	refs/remotes/origin/master
	master
	refs/heads/master
	v1.0
	refs/tags/v1.0

Significa que os seguintes comandos darão um resultado idêntico:	

	$ git log master
	
	$ git log refs/tags/v1.0
	

### Formato de Datas ###

O log que o git mantém permitirá a você fazer algumas coisas localmente, como:

	git log master@{yesterday}

	git log master@{1 month ago}

No qual é um atalho para 'onde o head do branch master estava ontem', etc. 
Veja que esse formato pode resultar em diferentes SHAs em diferentes 
computadores, mesmo se o branch master está atualmente apontando para o 
mesmo lugar.	


### Formato Ordinal ###

Esse formato dará a você o enésimo valor anterior de uma referência particular.
Por exemplo:

	git log master@{5}

dará a você o valor do quinto elemento do head master.

	
### Carrot Parent (^) ###

Isso dará a você o enésimo pai de um commit particular. Esse formato é útil 
sobre commits criados com merges - objetos commit que possuem mais de um pai 
direto.

	git log master^2
	
	
### Formato til (~) ###

O ~ dará a você o enésimo avô do objeto commit. Por exemplo,

	git log master~2
	
nos dará o primeiro pai do primeiro pai do commit que o master aponta. Isso é
equivalente a:

	git log master^^

Você também pode continuar fazendo isso. Os sequintes formatos apontarão para o
mesmo commit:

	git log master^^^^^^
	git log master~3^~2
	git log master~6

### Apontador Tree ###

Isso desambingua um commit da árvore para quem ele aponta. Se você quer o
SHA que um commit aponta, você pode adicionar o formato '^{tree}' no final dele.

	git log master^{tree}

### Formato Blob ###

Se você quer o SHA de um blob particular, você pode adicionar o caminho do blob
no final do treeish, assim:

	git log master:/path/to/file
	
### Range (..) ###

Finalmente, você pode especificar uma faixa de commits com o formato (..).
Isso dará a você todos os commits entre 7b593b5 e 51bea1 (onde 51bea1 é o 
mais recente), excluindo 7b593b5 mas incluindo 51bea1:

	git log 7b593b5..51bea1

Isso incluirá cada commit *desde* 7b593b:     

	git log 7b593b.. 
	
	