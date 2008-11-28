## Tags no Git  ##

### Tags "Peso-Leve"  ###

Nós podemos criar uma tag para referenciar um commit particular executando 
linkgit:git-tag[1] sem nenhum argumento.

    $ git tag stable-1 1b2e1d63ff

Depois disso, nós podemos usar a tag 'stable-1' para referenciar o commit 1b2e1d63ff.    

Isso cria uma tag "peso-leve", basicamente um branch que nunca se altera.
Se você também gostaria de incluir um comentário com a tag, e possivelmente 
assinar criptograficamente, então em vez disso nós podemos criar um *tag object* .

### Tag Objects ###

Se um dos **-a**, **-s**, ou **-u <key-id>** é passado, o comando cria uma tag 
object, e solicita uma mensagem da tag. A não ser que -m <msg> ou -F <arquivo> 
seja dado, um editor é iniciado para o usuário digitar a mensagem da tag.

Quando isso acontece, um objeto é adicionado para o banco de dados de objeto 
Git e a tag ref aponta para esse _tag object_, em vez realizar um commit dele.
A força disso é que você pode assinar a tag, então você pode verificar que 
este é o último commit correto.

    $ git tag -a stable-1 1b2e1d63ff

Na verdade é possível adicionar um tag em qualquer objeto, mas é mais comum 
colocar tags em objetos do tipo commit. (No código fonte do kernel do Linux, a 
primeira tag referencia uma árvore, em vez de um commit)   

### Tags Assinadas ###

Se você tem uma chave GPG configurada, você pode criar tags assinadas mais 
facilmente. Primeiro, provavelmente irá querer configurar o id de sua chave no 
seu arquivo _.git/condig_ ou _~.gitconfig_

    [user]
        signingkey = <gpg-key-id>
        
Você também pode configurá-lo com

    $ git config (--global) user.signingkey <gpg-key-id>
    
Agora você pode criar uma tag assinada através da substituição do **-a** 
pelo **-s**.

    $ git tag -s stable-1 1b2e1d63ff

Se você não tem sua chave GPG no seu arquivo de configuração, você pode 
realizar a mesmo coisa dessa forma:    
    
    $ git tag -u <gpg-key-id> stable-1 1b2e1d63ff