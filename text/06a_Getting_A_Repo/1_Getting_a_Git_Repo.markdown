## Conseguindo um Repositório Git ##

Então agora que nós já configuramos, precisamos de um repositório Git. Podemos 
fazer isso de duas maneiras - nós podemos *clonar* um já existente, ou podemos
*inicializar* um dentro de algum projeto que ainda não tenha controle de versão
, ou a partir de um diretório vazio.

### Clonando um Repositório ###

Para que consigamos uma cópia de um projeto, você irá precisar saber qual a URL
- a localização do repositório - do projeto Git.
Git pode operar sobre muitos diferentes protocolos, então ele pode iniciar com 
ssh://, http(s)://, git://, ou só o nome de usuário (no qual o git assumirá 
ssh). Alguns repositórios podem ser acessados sobre mais do que um protocolo. 
Por exemplo, o código fonte do próprio Git pode ser clonado sobre o protocolo
git:// :

    git clone git://git.kernel.org/pub/scm/git/git.git

ou sobre http:

    git clone http://www.kernel.org/pub/scm/git/git.git

O protocolo git:// é mais rápido e mais eficiente, mas algumas vezes é
necessário usar http quando estão por tráz de firewalls corporativo ou
que você tenha. Nesses casos você deveria então ter um novo diretório chamado 
'git' que contém todos os códigos fontes do Git e o histórico - que é 
basicamente uma cópia do que estava no servidor.

Por padrão, o Git nomeará o novo diretório do projeto de sua clonagem de acordo
com o nome do arquivo no ultímo de nível na URL antes de '.git'.
(ex.: *git clone
http://git.kernel.org/linux/kernel/git/torvalds/linux-2.6.git* resultará em um 
novo diretório chamado 'linux-2.6')

### Inicializando um Novo Repositório ###

Suponha que você tem um tarball chamado project.tar.gz com seu trabalho 
inicial. Você pode colocar ele sobre um controle de revisões do git como segue.

    $ tar xzf project.tar.gz
    $ cd project
    $ git init

Git irá reponder

    Initialized empty Git repository in .git/

Agora você tem um diretório de trabalho inicializado - você pode notar um novo
diretório criado chamado ".git".

[gitcast:c1_init](GitCast #1 - Configurando , Inicializando e Clonando)