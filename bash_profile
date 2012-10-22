if [ ! -e ~/.vimrc ] ; then 
	ln -s ~/bash_conf/vimrc ~/.vimrc
fi
if [ ! -e ~/.gitconfig ] ; then
	ln -s ~/bash_conf/gitconfig ~/.gitconfig 
fi
if [ ! -e ~/.gitignore_global ] ; then
	ln -s ~/bash_conf/gitignore_global ~/.gitignore_global
fi

if [ -e /etc/bash.bashrc ] ; then
	source /etc/bash.bashrc
fi
if [ -e ~/bash_conf/bashrc ] ; then
	source ~/bash_conf/bashrc
fi
if [ -e ~/bash_conf/bash_dont_think.sh ] ; then
	source ~/bash_conf/bash_dont_think.sh
fi
if [ -e ~/bash_conf/git-completion.bash ] ; then
	source ~/bash_conf/git-completion.bash
fi

if [ -f `brew --prefix`/etc/bash_completion ]; then
  . `brew --prefix`/etc/bash_completion
fi

if [ -e ~/nvm/nvm.sh ] ; then
	source ~/nvm/nvm.sh
	source ~/nvm/bash_completion
fi
