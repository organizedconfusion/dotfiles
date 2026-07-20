alias rm='rm -i'
alias cp='cp -i'
alias ls='ls --color=auto -F'
alias la='ls --color=auto -lAFh'
alias tree='tree -C'

fe() { fzf -m --preview='batcat --color=always {} --theme "everforest-medium"' --bind 'enter:become(nvim {+})'; }

#alias vi='nvim'
#alias vim='nvim'
