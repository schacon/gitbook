## Customizando o Git ##

linkgit:git-config[1]

### Alterando o seu editor ###

	$ git config --global core.editor emacs

### Adicionando Aliases ###
	
	$ git config --global alias.last 'cat-file commit HEAD'
	
	$ git last
	tree c85fbd1996b8e7e5eda1288b56042c0cdb91836b
	parent cdc9a0a28173b6ba4aca00eb34f5aabb39980735
	author Scott Chacon <schacon@gmail.com> 1220473867 -0700
	committer Scott Chacon <schacon@gmail.com> 1220473867 -0700

	fixed a weird formatting problem
	
	$ git cat-file commit HEAD
	tree c85fbd1996b8e7e5eda1288b56042c0cdb91836b
	parent cdc9a0a28173b6ba4aca00eb34f5aabb39980735
	author Scott Chacon <schacon@gmail.com> 1220473867 -0700
	committer Scott Chacon <schacon@gmail.com> 1220473867 -0700

	fixed a weird formatting problem

### Adicionando Cores ###

Veja todas as opções de cores na documentação de linkgit:git-config[1] 

	$ git config color.branch auto
	$ git config color.diff auto
	$ git config color.interactive auto
	$ git config color.status auto

Ou, você pode configurar todos eles com a opção color.ui:    

	$ git config color.ui true
	
### Commit Template ###

	$ git config commit.template '/etc/git-commit-template'
	
### Log Format ###

	$ git config format.pretty oneline


### Outras Opções de Configuração ###

Existem também um número de opções interessantes para packing, gc-ing, merging,
remotes, branches, http transport, diffs, paging, whitespace e mais.  Se você
quer saber mais dê uma olhada na documentação do linkgit:git-config[1].