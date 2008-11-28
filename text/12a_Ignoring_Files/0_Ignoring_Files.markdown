## Ignorando Arquivos ##

Um projeto frequentemente irá gerar arquivos que você 'não' quer gerenciar com 
o git.
Isso tipicamente inclui arquivos gerados por um processo de construção ou 
arquivos de backup temporário feitos pelo seu editor. É claro, 'não' gerenciar 
arquivos com o git é apenas uma questão de 'não' chamar "'git-add'" nele. Mas
isso rapidamente torna-se irritante ter esses arquivos não selecionados 
espalhados por ai; eles fazem o "'git add .'" e "'git commit -a'" praticamente 
inúteis, e eles permanecem sendo visualizados pelo "'git status'".

Você pode dizer ao git para ignorar certos arquivos através da criação do 
arquivo chamado .gitignore na raiz do seu diretório de trabalho, como por exemplo:

    # Linhas que iniciam com '#' são considerados comentários
    # Ignora qualquer arquivo chamado foo.txt.
    foo.txt
    # Ignora arquivos html (gerados),
    *.html
    # com exceção de foo.html que é mantido manualmente.
    !foo.html
    # Ignora objetos e arquivos históricos.
    *.[oa]

Veja linkgit:gitignore[5] para uma detalhada explicação da sintaxe. Você também 
pode colocar arquivos .gitignore em outros diretórios na sua árvore de trabalho e
eles se aplicarão a esses diretórios e subdiretórios. Os arquivos `.gitignore` 
podem ser adicionados em seu repositório como todos outros arquivos (só execute 
`git add .gitignore` e `git commit`, como sempre) que é conveniente quando os 
padrões de exclusão (por exemplo os padrões que casam com arquivos construidos)
também farão sentido para outros usuários que clonam seu repositório.

Se você escolhe padrões de exclusão para afetar somente certos repositórios ( 
ao invés de cada repositório para um dado projeto), você pode por exemplo 
colocá-los em um arquivo em seu repositório chamado .git/info/exclude, ou em 
qualquer arquivo especificado pela variável `core.excludesfile`. Alguns 
comandos git também fornecem padrões de exclusão diretamente na linha de 
comando.
Veja linkgit:gitignore[5] para mais detalhes.
