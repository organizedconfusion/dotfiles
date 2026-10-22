# Git branch in prompt
if [ -f /usr/share/git-core/contrib/completion/git-prompt.sh ]; then
    source /usr/share/git-core/contrib/completion/git-prompt.sh
elif [ -f /usr/lib/git-core/git-sh-prompt ]; then
    source /usr/lib/git-core/git-sh-prompt
fi

export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=1

# Customize PS1 to show git branch and status, and any stopped jobs

# Your updated PS1 prompt
export PS1='\[\e[01;32m\]\u@\h \[\e[01;34m\]\w\[\e[01;31m\]$(__git_ps1 " (%s)")\[\e[01;35m\]$(j=$(jobs -p | wc -l); ((j>0)) && echo " ($j)")\[\e[0m\]\$ '
