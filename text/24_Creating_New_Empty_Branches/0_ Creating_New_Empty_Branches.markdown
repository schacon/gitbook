## Criando Novos Branches Vazios ##

Ocasionalmente, você pode querer manter branches em seu repositório que não 
compartilha um ancestral com o seu código. Alguns exemplos disso podem ser 
documentações geradas ou alguma coisa nessas linhas. Se você quer criar um novo
branch que não usa seu código base atual como pai, você pode criar um branch 
vazio assim:

    git symbolic-ref HEAD refs/heads/newbranch 
    rm .git/index 
    git clean -fdx 
    <do work> 
    git add your files 
    git commit -m 'Initial commit'
    
[gitcast:c9-empty-branch]("GitCast #7: Criando Branches Vazios")
