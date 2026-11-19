# .bashrc

# Source global definitions
if [ -f /etc/bash.bashrc ]; then
    . /etc/bash.bashrc
elif [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) PATH="$HOME/.local/bin:$PATH" ;;
esac
export PATH
export COLORTERM=truecolor
export EDITOR=nvim

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Machine-specific settings (not tracked)
[ -f ~/.bashrc.local ] && . ~/.bashrc.local

IGNOREEOF=10

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
