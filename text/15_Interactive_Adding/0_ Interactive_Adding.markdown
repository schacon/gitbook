## Seleção Interativa ##

Seleção interativa é realmente uma ótima forma de trabalhar e visualizar o index
do Git. De início, simplesmente digite 'git add -i'. O Git mostrará a você 
todos os arquivos modificados que você tem e seus status.

	$>git add -i
	           staged     unstaged path
	  1:    unchanged        +4/-0 assets/stylesheets/style.css
	  2:    unchanged      +23/-11 layout/book_index_template.html
	  3:    unchanged        +7/-7 layout/chapter_template.html
	  4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown

	*** Commands ***
	  1: status	  2: update	  3: revert	  4: add untracked
	  5: patch	  6: diff	  7: quit	  8: help
	What now> 

Nesse caso, podemos ver que existem 5 arquivos modificados que não foram 
adicionados em nosso index ainda (sem seleção), e até mesmo a quantidade de 
linhas que foram adicionadas e removidas de cada um. Então ele mostra-nos um
menu interativo mostrando o que podemos fazer.

Se quisermos selecionar esses arquivos, podemos digitar '2' ou 'u' para o modo
de atualização. Então eu posso especificar quais arquivos eu quero selecionar
( adicionar no index ) através da digitação dos números que correspondem aos
arquivos (nesse caso, 1-4)

	What now> 2
	           staged     unstaged path
	  1:    unchanged        +4/-0 assets/stylesheets/style.css
	  2:    unchanged      +23/-11 layout/book_index_template.html
	  3:    unchanged        +7/-7 layout/chapter_template.html
	  4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	Update>> 1-4
	           staged     unstaged path
	* 1:    unchanged        +4/-0 assets/stylesheets/style.css
	* 2:    unchanged      +23/-11 layout/book_index_template.html
	* 3:    unchanged        +7/-7 layout/chapter_template.html
	* 4:    unchanged        +3/-3 script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	Update>> 

Se teclar enter, serei levado de volta para o menu principal onde posso ver
que arquivos que possuem o status modificado:    

	What now> status
	           staged     unstaged path
	  1:        +4/-0      nothing assets/stylesheets/style.css
	  2:      +23/-11      nothing layout/book_index_template.html
	  3:        +7/-7      nothing layout/chapter_template.html
	  4:        +3/-3      nothing script/pdf.rb
	  5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown

Nós podemos ver o primeiro dos quatro arquivos selecionados e o último que 
ainda não está. Isso é basicamente uma forma resumida para ver a mesma 
informação que vemos quando executamos 'git status' a partir da linha de comando:

	$ git status
	# On branch master
	# Changes to be committed:
	#   (use "git reset HEAD <file>..." to unstage)
	#
	#	modified:   assets/stylesheets/style.css
	#	modified:   layout/book_index_template.html
	#	modified:   layout/chapter_template.html
	#	modified:   script/pdf.rb
	#
	# Changed but not updated:
	#   (use "git add <file>..." to update what will be committed)
	#
	#	modified:   text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	#

Existe um número de coisas úteis que podemos fazer, incluindo deselecionar 
arquivos (3: revert), adicionar arquivos não selecionados (4: add untracked), 
e ver as diferenças (6: diff). Isso tudo de forma muito simples. Contudo, 
existe um comando muito legal aqui, que é selecionar patches (5: patch).

Se você digitar '5' ou 'p' no menu, git mostrará a você a diferença por pacth
e perguntar se você quer selecionar cada um. Na verdade essa é uma 
forma que você pode selecionar para um commit partes de um arquivo editado. Se
você editou um arquivo e quer somente realizar um commit de uma parte dele e 
não a parte inacabada, ou commit da documentação ou espaços em branco, você 
pode usar 'git add -i' para fazê-lo facilmente.

Aqui eu tenho selecionado alterações para o arquivo book_index_template.html, 
mas não para todos eles:

	         staged     unstaged path
	1:        +4/-0      nothing assets/stylesheets/style.css
	2:       +20/-7        +3/-4 layout/book_index_template.html
	3:        +7/-7      nothing layout/chapter_template.html
	4:        +3/-3      nothing script/pdf.rb
	5:    unchanged      +121/-0 text/14_Interactive_Rebasing/0_ Interactive_Rebasing.markdown
	6:    unchanged       +85/-0 text/15_Interactive_Adding/0_ Interactive_Adding.markdown

Quando você terminar de fazer as alterações para o index através do 
'git add -i', você simplesmente sai (7: quit) e então executa 'git commit' para
realizar o commit das alterações selecionadas. Lembre-se **não** execute 
'git commit -a' que descartará todas as alterações que você cuidadosamente fez
e simplemente realizará um commit de tudo.

[gitcast:c3_add_interactive]("GitCast #3: Seleção Interativa")
