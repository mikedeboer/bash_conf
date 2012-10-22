# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

alias c=clear
alias df='df -h'
alias du='du -h'
alias psg='ps -ef | grep'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias ls='ls -hF'

export PATH=/usr/local/bin:/usr/local/sbin:/usr/local/mysql/bin:$HOME/.rvm/bin:$PATH
if [ $(uname -s) = 'Darwin' ] ; then
	export EDITOR='/usr/local/bin/mate -w'
else
	export EDITOR='vim'
fi

export GREP_OPTIONS='--color=auto'
export CLICOLOR=1
export LC_CTYPE=en_US.UTF-8
export LSCOLORS=cxfxgxdxbxexexbxbxcxcx