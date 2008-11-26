### Instalando a partir do Código Fonte ###

Em resumo, em um sistema baseado em Unix, você pode baixar o código fonte do 
Git em [Git Download Page](http://git-scm.com/download), e então executar 
essas linhas :

    $ make prefix=/usr all ;# com seu próprio usuário
    $ make prefix=/usr install ;# como root

Você precisará dessas bibliotecas instaladas [expat](http://expat.sourceforge.net/), 
[curl](http://curl.linux-mirror.org),
[zlib](http://www.zlib.net), e [openssl](http://www.openssl.org) 
- embora com uma possível exceção do *expat*, esse normalmenete já existe 
no sistema.