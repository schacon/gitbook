### Objeto Tag ###

[fig:object-tag]

Um objeto tag contém um nome de objeto (chamado simplesmente de 'object'),
tipo de objeto, nome da tag, o nome da pessoa ('tagger') que criou a tag, e uma 
mensagem, que pode conter um assinatura, como pode ser visto usando 
linkgit:git-cat-file[1]:

    $ git cat-file tag v1.5.0
    object 437b1b20df4b356c9342dac8d38849f24ef44f27
    type commit
    tag v1.5.0
    tagger Junio C Hamano <junkio@cox.net> 1171411200 +0000

    GIT 1.5.0
    -----BEGIN PGP SIGNATURE-----
    Version: GnuPG v1.4.6 (GNU/Linux)

    iD8DBQBF0lGqwMbZpPMRm5oRAuRiAJ9ohBLd7s2kqjkKlq1qqC57SbnmzQCdG4ui
    nLE/L9aUXdWeTFPron96DLA=
    =2E+0
    -----END PGP SIGNATURE-----

Veja o comando linkgit:git-tag[1] para aprender como criar e verificar objetos
tag.  (Note que linkgit:git-tag[1] pode ser também usado para criar 
"tags peso-leve", que não são objetos tag, mas só simples referências dos quais 
os nomes iniciam com "refs/tags/").