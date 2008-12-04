## Git e Email ##

### Enviando patches para um projeto ###

Se você já possui algumas alterações, a forma mais simples de fazê-lo é 
enviá-los como patches por email:

Primeiro, use linkgit:git-format-patch[1]; por exemplo:

    $ git format-patch origin

produzirá uma série numerada de arquivos no diretório atual, um para cada
patch do branch atual, mas não do origin/HEAD.

Você pode então importar eles para seu cliente de email e enviá-los.
Contudo, se você tem que enviar todos de uma vez, você pode preferir usar
o script linkgit:git-send-email[1] para automatizar o processo.
Consulte primeiro a lista de email do seu projeto para determinar como eles
preferem que os patches sejam manipulados.


### Importando patches para o projeto ###

Git também provê uma ferramenta chamada linkgit:git-am[1] ( uma abreviação de
"apply mailbox"), para importar uma série de patches recebidos.
Grave todas as mensagens que contém patches, em orderm, para um arquivo mailbox 
simples, digamos "patches.mbox", então execute

    $ git am -3 patches.mbox

Git aplicará cada patch em ordem; se algum conflito for encontrado, ele irá
parar, e você pode corrigir os conflitos como descrito em 
"<<resolving-a-merge,Resolvendo um merge>>". (A opção "-3" chama o git para 
realizar um merge; se você prefere exatamente abortar e deixar sua árvore e 
index intácta, você pode omitir essa opção.)

Somente o index é atualizado com o resultado da resolução do conflito, ao invés
de criar um novo commit, execute

    $ git am --resolved

e o git criará o commit para você e continua aplicando o restante dos patches do
mailbox.    

O resultado final será uma série de commits, um para cada patch no mailbox 
original,cada um com o autor e a mensagem de commit trazido da mensagem contido
em cada patch.
