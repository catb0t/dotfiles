#!/bin/bash
source ~/.git-prompt.sh
source ~/.bash_functions

alias dati='date "+%F %T"'
alias dt=''
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo `dati` `pwd` $$ $USER "$(history 1)" >> ~/.bash_eternal_history'

alias ls='ls --color=always -a'
alias ll='ls -alF'
alias dir='ls -al | grep ^d'
alias nonl='echo -n'
alias ek='echo'
alias cls='clear'
alias woo='fortune'
alias say='espeak -v el'
alias src='source'
alias resrc='source ~/.bashrc'
alias apt="sudo apt"
#alias alert='notify-send --urgency=normal -i "$([ $? = 0 ] && echo terminal || echo error)""$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export rc=~/.bashrc
export HISTSIZE=
export HISTFILESIZE=
export HISTTIMEFORMAT="%d-%m-%y %H:%M "
#export HISTCONTROL=ignoredups
export ED=vim


function nonzero_return() {
	RETVAL=$?
	[ $RETVAL -ne 0 ] && echo "$RETVAL | "
}

asm () {
  local dir
  dir=$(basename "$(pwd)");
  command rm *.o $dir
  $1 -felf64 $dir.s -o $dir.o && gcc $2 -fPIC $dir.o -o $dir
  command rm *.o
}


up () {
	ek
	echo removing the lock...
	sudo rm -rf /var/lib/apt/lists/lock
	ek
	if [ $1 ]; then
		echo "updating package lists (this may take a while)..."
		ek
		sudo apt update
	fi
	echo upgrading packages...
	ek
	sudo apt upgrade
	echo "automatically removing unecessary packages (press CTRL-C to stop)..."
	sudo apt-get autoremove
	ek
	echo updating the menu...
	sudo chmod -cR -x /usr/share/menu/*
	sudo update-menus
	sudo updatedb
}


#greeter () {
#
#	HOUR=`date +%H | tr -dc '0-9'`
#	if [ ! $HOUR ] | (( "$HOUR" <= '11' )); then
#		TOD='Morning'
#	elif (("$HOUR" >= '12')) && (("$HOUR" <= '16')); then
#		TOD='Afternoon'
#	elif (("$HOUR" >= '17')) && (("$HOUR" <= '23')); then
#		TOD='Evening'
#	fi
#
#	woo | tee /etc/motd
#	echo
#	echo $TOD, Cat.
#
#	/usr/bin/mouse ~/projects/mouse/code/time-chap/time-chap-once.m02
#}

_init () {
	greeter
}

export FACTOR_ROOTS=/home/cat/projects/git/exercism.factor
export HISTFILE=/home/cat/.bash_history
export HISTFILESIZE=
export HISTSIZE=
export HISTTIMEFORMAT='%d-%m-%y %H:%M '
export PAGER='less -X'
export PATH=/home/cat/projects/factor/factor:/home/cat/bin:/home/cat/.rakudobrew/bin:/home/cat/.rakudobrew/moar-nom/install/share/perl6/site/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games

export PS1='\n\[\e[1;35m\]`nonzero_return`\[\e[1;34m\]\u @ \[\e[1;32m\]\h : \[\e[1;31m\]\w\[\e[1;32m\]`git_prompt` \[\e[1;35m\]$ \[\e[m\]'
export PS2='> '
export PS4='+ '
alias make='make -j'

_init

PATH="/home/cat/perl5/bin${PATH:+:${PATH}}"; export PATH;
PERL5LIB="/home/cat/perl5/lib/perl5${PERL5LIB:+:${PERL5LIB}}"; export PERL5LIB;
PERL_LOCAL_LIB_ROOT="/home/cat/perl5${PERL_LOCAL_LIB_ROOT:+:${PERL_LOCAL_LIB_ROOT}}"; export PERL_LOCAL_LIB_ROOT;
PERL_MB_OPT="--install_base \"/home/cat/perl5\""; export PERL_MB_OPT;
PERL_MM_OPT="INSTALL_BASE=/home/cat/perl5"; export PERL_MM_OPT;
export PATH=$HOME/bin:$PATH
