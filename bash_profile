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
if [ -e ~/bash_conf/hg-completion.bash ] ; then
	source ~/bash_conf/hg-completion.bash 
fi

if [[ $(which brew) != '' && -f `brew --prefix`/etc/bash_completion ]]; then
	source `brew --prefix`/etc/bash_completion
fi

if [ -e ~/.nvm/nvm.sh ] ; then
	source ~/.nvm/nvm.sh
	source ~/.nvm/bash_completion
fi

export LC_CTYPE='en_US.UTF-8'
# If Sublime Text CLI utility is installed and available, use it as our default editor.
if [[ $(which subl) != '' ]]; then
	export EDITOR='subl -w'
fi

if [ -e ~/.rvm/scripts/rvm ] ; then
	source ~/.rvm/scripts/rvm # Load RVM into a shell session as a function
fi

#if [ -e ~/Projects/emsdk_portable/emsdk_add_path ] ; then
#	curdir=`pwd`
#    cd ~/Projects/emsdk_portable
#	source ~/Projects/emsdk_portable/emsdk_add_path
#	cd $curdir
#fi

#if [ -e ~/addon-sdk/bin/activate ] ; then
#	curdir=`pwd`
#	cd ~/addon-sdk && source ~/addon-sdk/bin/activate
#	cd $curdir
#fi

export DOCKER_HOST=tcp://192.168.59.103:2376
export DOCKER_CERT_PATH=/Users/mikedeboer/.boot2docker/certs/boot2docker-vm
export DOCKER_TLS_VERIFY=1

if [ -e ~/Projects/depot_tools ] ; then
	export PATH=$PATH:~/Projects/depot_tools
fi
