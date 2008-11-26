## Diretório Git e Diretório de Trabalho ##

### O Diretório Git ###

O 'diretório git' é o diretório que armazena todos os históricos Git e meta
informações do seu projeto - incluindo todos os objetos (commits, trees,blobs,
tags), todos os ponteiros onde os diferentes branches estão e muito mais.

Existe somente um Diretório Git por projeto (o oposto de um por sub diretório
como no SVN our CVS), e que o diretório é (por padrão, embora não 
necessariamente) '.git' na raiz do seu projeto. Se você olha no conteúdo desse
diretório, você pode ver todos os seus importantes arquivos:

    $>tree -L 1
    .
    |-- HEAD         # aponta para o seu branch atual
    |-- config       # suas configurações preferenciais
    |-- description  # descrição do seu projeto 
    |-- hooks/       # pre/post action hooks
    |-- index        # arquivo de index (veja a próxima seção)
    |-- logs/        # um histórico de onde seus branches tem estado
    |-- objects/     # seus objetos (commits, trees, blobs, tags)
    `-- refs/        # ponteiros para os seus branches

(podem existir alguns outros arquivos/diretórios aqui mas eles não são importantes agora)


### O Diretório de Trabalho ###

O 'diretório de trabalho' do Git é o diretório que detém o atual checkout dos 
arquivos sobre o qual você está trabalhando. Arquivos nesse diretório são
frequentemente removidos ou renomeados pelo Git quando você troca de branches - 
isso é normal. Todos os seus históricos são armazenados no diretório Git; o 
diretório de trabalho é simplesmente um lugar temporário de checkout onde você 
pode modificar os arquivos até o próximo commit.