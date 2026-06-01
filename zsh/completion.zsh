# =========================================================
# Completion styles
# =========================================================
# Sourced after plugins.zsh so fzf-tab is already loaded.

# ---------- zsh completion system ----------

# Case-insensitive matching: "doc" -> "Documents"
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Group completions and label each group (required for fzf-tab grouping)
zstyle ':completion:*:descriptions' format '[%d]'

# Colorize filenames in completion using LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Disable zsh's own menu so fzf-tab can take over
zstyle ':completion:*' menu no

# Keep git branches in recency order, not alphabetical
zstyle ':completion:*:git-checkout:*' sort false

# ---------- fzf-tab ----------

# Inherit FZF_DEFAULT_OPTS look (height, border, layout)
zstyle ':fzf-tab:*' use-fzf-default-opts yes

# Cycle between completion groups with < and >
zstyle ':fzf-tab:*' switch-group '<' '>'

# Only Enter accepts — disable `/` auto-accepting on directory completion
zstyle ':fzf-tab:*' continuous-trigger ''

# Preview directory contents when completing `cd`
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'

# tmux
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
