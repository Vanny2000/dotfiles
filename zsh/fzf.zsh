# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results

# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --pointer="  "
  --preview-window=right:65%:wrap:border-left
'

# Preview dispatcher: images via chafa, text via bat, fallback to file metadata
export _FZF_PREVIEW_CMD='
  mime=$(file --mime-type -b -- {});
  case "$mime" in
    image/*) chafa -f symbols -s "${FZF_PREVIEW_COLUMNS}x${FZF_PREVIEW_LINES}" -- {} ;;
    text/*|application/json|application/xml|application/javascript|inode/x-empty)
      bat --color=always --style=plain,numbers --line-range=:500 -- {} ;;
    *) file -- {} ;;
  esac'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# Ctrl+F: file picker — text files open in $EDITOR, others in the system handler
_fzf_file_no_hidden() {
  local cmd result mime opener
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") || { zle reset-prompt; return }

  mime=$(file --mime-type -b -- "$result")
  case "$mime" in
    text/*|application/json|application/xml|application/javascript|inode/x-empty)
      opener="${EDITOR:-nvim}" ;;
    *)
      # macOS: open; Linux: xdg-open
      opener=$(command -v open || command -v xdg-open) ;;
  esac

  BUFFER="$opener ${(q)result}"
  zle accept-line
}
zle -N _fzf_file_no_hidden
