export RIPGREP_CONFIG_PATH="$HOME/ripgreprc"

# Only add tools that are actually installed
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"
[ -x /home/linuxbrew/.linuxbrew/bin/brew ] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[ -d /usr/local/go/bin ] && export PATH=$PATH:/usr/local/go/bin
[ -d "$HOME/go/bin" ] && export PATH=$PATH:$HOME/go/bin
# WSL only
[ -d /mnt/c/Windows/System32/WindowsPowerShell/v1.0 ] && export PATH=$PATH:/mnt/c/Windows/System32/WindowsPowerShell/v1.0
