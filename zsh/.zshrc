# OPENSPEC:START
# OpenSpec shell completions configuration
fpath=("/Users/thuan/.oh-my-zsh/custom/completions" $fpath)
autoload -Uz compinit
compinit
# OPENSPEC:END

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"
export XDG_CONFIG_HOME="$HOME/.config"
export PATH="$HOME/.composer/vendor/bin:$PATH"
# Set name of the theme to load
# ZSH_THEME="powerlevel10k/powerlevel10k"

# Plugins
plugins=(
  git
  # zsh-autosuggestions
  fzf-tab
  web-search
)

source $ZSH/oh-my-zsh.sh

# Aliases
alias wip="git add . && git commit -m 'updated'"
alias gba="git branch --sort=-committerdate"
alias art="php artisan"
alias nah="git reset --hard;git clean -df"
alias nrd="npm run dev"
alias mp="git switch main && git pull origin main"
alias c="pbcopy"
alias v="pbpaste"
alias lab="~/bashscripts/cybersecurity-lab.sh"
alias srb="~/bashscripts/shoprunback-setup.sh"
alias n="nvim"
alias air="~/go/bin/air"
alias ls="eza --icons=auto"
alias cd="z"
alias ts="tailscale"
alias bt="Budget_Tracker"
alias cc="claude --dangerously-skip-permissions"

# Zoxide
eval "$(zoxide init zsh)"

# Prompt
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

export PATH="$HOME/.composer/vendor/bin:$PATH"

# Docker Desktop (mac only)
[ -f "/Users/thuan/.docker/init-zsh.sh" ] && source "/Users/thuan/.docker/init-zsh.sh"

# Herd PHP binaries/config (mac only)
if [ -d "/Users/thuan/Library/Application Support/Herd" ]; then
  export PATH="/Users/thuan/Library/Application Support/Herd/bin/:$PATH"
  export HERD_PHP_82_INI_SCAN_DIR="/Users/thuan/Library/Application Support/Herd/config/php/82/"
  export HERD_PHP_74_INI_SCAN_DIR="/Users/thuan/Library/Application Support/Herd/config/php/74/"
  export HERD_PHP_81_INI_SCAN_DIR="/Users/thuan/Library/Application Support/Herd/config/php/81/"
  export HERD_PHP_80_INI_SCAN_DIR="/Users/thuan/Library/Application Support/Herd/config/php/80/"
  export HERD_PHP_83_INI_SCAN_DIR="/Users/thuan/Library/Application Support/Herd/config/php/83/"
fi

# Editor
export EDITOR="nvim"

# OpenSSL (brew on mac)
[ -d "/usr/local/opt/openssl@3/bin" ] && export PATH="/usr/local/opt/openssl@3/bin:$PATH"

# yazi wrapper
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# History setup
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt share_history 
setopt hist_expire_dups_first
setopt hist_ignore_dups
setopt hist_verify

# history search with arrows
bindkey '^[[A' history-search-backward
bindkey '^[[B' history-search-forward

# Autosuggestions + Syntax highlighting
[ -f "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh" ] && source "/opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
[ -f "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ] && source "/opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

# Env secrets
[ -f ~/.zsh_secrets ] && source ~/.zsh_secrets

# Starship prompt
eval "$(starship init zsh)"

# Pipx bin path
export PATH="$PATH:$HOME/.local/bin"

# bun completions
[ -s "/Users/thuan/.bun/_bun" ] && source "/Users/thuan/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
