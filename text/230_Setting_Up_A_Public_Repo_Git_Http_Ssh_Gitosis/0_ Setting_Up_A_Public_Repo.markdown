## Configurando um Repositório Público ##

Assuma que seu repositório pessoal está no diretório ~/proj. Primeiro
criamos um novo clone do repositório e pedimos ao git-daemon que ele
seja público:

    $ git clone --bare ~/proj proj.git
    $ touch proj.git/git-daemon-export-ok

O diretório resultante proj.git contém um repositório git "mínimo" -- ele 
é só o conteúdo do diretório ".git", sem qualquer arquivo dentro dele.

Depois, copie o proj.git para o servidor onde você planeja hospedar o
repositório público. Você pode usar scp, rsync, ou qualquer coisa mais 
conveniente.

### Exportando um repositório git via protocolo git ###

Esse é o método preferido.

Se alguém então administrar o servidor, ele deveráo pedir a você qual o
diretório para colocar o repositório dentro, e qual URL git:// aparecerá nele.

Se não fosse assim, tudo que você precisa para fazer isso é iniciar 
linkgit:git-daemon[1]; ele ouvirá a porta 9418. Por padrão, permitirá acessar
qualquer diretório que se pareça com um diretório git e contém o arquivo mágico
git-daemon-export-ok. Passando alguns caminhos de diretórios como argumentos 
para git-daemon restringirá mais ainda esses caminhos exportados.

Você pode também executar git-daemon como um serviço inetd; veja as páginas
de manual do linkgit:git-daemon[1] para mais detalhes. (Veja especialmente a
seção de exemplos.)

### Exportando um repositório git via http ###

O protocolo git dá melhor desempenho e confiabilidade, mas sobre host com
um servidor web configurado, exportar via http pode ser mais simples de
configurar.

Tudo que você precisa fazer é colocar o recém criado repositório git
mínimo no diretório que está exportado pelo web server, e fazer alguns 
ajustes para dar os clientes webs algumas informações extras que eles
precisam:

    $ mv proj.git /home/you/public_html/proj.git
    $ cd proj.git
    $ git --bare update-server-info
    $ chmod a+x hooks/post-update

(Para uma explicação das últimas duas linhas, veja
linkgit:git-update-server-info[1] e linkgit:githooks[5].)

Divulgue a URL do proj.git. Qualquer um então deveria ser capaz de clonar
ou receber dessa URL, por exemplo com a linha de comando:

    $ git clone http://yourserver.com/~you/proj.git
