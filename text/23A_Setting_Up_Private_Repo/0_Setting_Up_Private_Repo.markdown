## Configurando um Repositório Privado ##

Se você precisa configurar um repositório privado e quer fazê-lo localmente,
em vez de usar uma solução de hospedada, você tem inúmeras opções.

### Acesso a repositório através do SSH ###

Geralmente, a solução mais fácil é simplesmente usar o Git sobre SSH. Se os 
usuários já possuem contas ssh na máquina, você pode colocar o repositório em 
qualquer lugar que eles tenham acesso deixando eles acessarem através de logins
ssh. Por exemplo, digamos que você tem um repositório que você quer hospedar.
Você pode exportá-lo como um repositório mínimo e então enviá-lo para dentro 
do seu servidor assim:

	
	$ git clone --bare /home/user/myrepo/.git /tmp/myrepo.git
	$ scp -r /tmp/myrepo.git myserver.com:/opt/git/myrepo.git
	
Então alguém pode clonar com uma conta ssh no servidor myserver.com via:   

	$ git clone myserver.com:/opt/git/myrepo.git

Que simplesmente solicitará suas senhas ssh ou usar suas chaves públicas, 
contanto que eles tenham a autenticação ssh configurada.

### Acesso de Múltiplos Usuários usando Gitosis ###

Se você não quer configurar contas separadas para cada usuário, você pode usar
uma ferramente chamada Gitosis. No Gitosis, existe um arquivo authorized_keys
que contém uma chave pública para todos os autorizados a acessar o 
repositório, e então todos usam o usuário 'git' para realizar pushes e pulls.

[Instalando e Configurando o Gitosis](http://www.urbanpuddle.com/articles/2008/07/11/installing-git-on-a-server-ubuntu-or-debian)