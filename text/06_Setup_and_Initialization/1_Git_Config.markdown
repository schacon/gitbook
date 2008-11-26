### Git Config ###

A primeira coisa que você vai querer fazer é configurar o seu nome e 
o endereço de email para o Git usá-lo para assinar seus commits.

    $ git config --global user.name "Scott Chacon"
    $ git config --global user.email "schacon@gmail.com"

Isso irá configurar um arquivo em seu diretório home que pode ser usado por 
qualquer um dos seus projetos. Por padrão esse arquivo é *~/.gitconfig* e o 
conteúdo irá se parecer com isso:
   
    [user]
            name = Scott Chacon
            email = schacon@gmail.com
            

Se você quer sobrescrever esses valores para um projeto específico (para usar
um endereço de email do trabalho, por exemplo), você pode executar o comando
*git config* sem a opção *--global* naquele projeto. Isso irá adicionar uma 
seção [user] como mostrado acima para o arquivo *.git/config* na raiz de 
seu projeto.