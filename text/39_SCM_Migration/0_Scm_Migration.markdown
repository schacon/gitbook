## Migração de um SCM ##

Então você tomou a decisão de mudar de seu sistema atual e converter todo o 
seu projeto para o Git. Como você pode fazer isso facilmente?

### Importando do Subversion ###

Git vem com um script chamado git-svn que tem um comando clone que importará um 
repositório subversion dentro de um novo repositório git. Existe também uma 
ferramenta grátis no GitHub que pode fazer isso para você.
	
	$ git-svn clone http://my-project.googlecode.com/svn/trunk new-project

Isso dará a você um novo repositório Git com todo o histórico do repositório
original do Subversion. Isso levará um bom tempo, geralmente, desde o início com
a versão 1 e checkouts e commits locais a cada simples revisão um por um.

### Importando do Perforce ###

Em contrib/fast-import você encontrará o script git-p4, que é um script em Python
que importará um repositório Perforce para você.

	$ ~/git.git/contrib/fast-import/git-p4 clone //depot/project/main@all myproject
	

### Importando Outros ###

Existem outros SCMs que são listados no Git Survey, deveria encontrar a
documentação de importação deles. !!A FAZER!!

* CVS
* Mercurial (hg)

* Bazaar-NG
* Darcs
* ClearCase
	
