#!/bin/bash

# Clone the bare dotfiles repository
git clone --bare https://github.com/Vanny2000/dotfiles.git $HOME/dotfiles

# Create a function to manage dotfiles with the correct Git command
function dots {
   /usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME "$@"
}

# Ensure an alias is set up for future sessions
echo "alias dots='/usr/bin/git --git-dir=$HOME/dotfiles --work-tree=$HOME'" >> $HOME/.zshrc

# Backup existing dotfiles that conflict
mkdir -p $HOME/.config-backup
dots checkout 2>&1 | grep -E "^\s+" | awk '{print $1}' | xargs -I{} mv {} $HOME/.config-backup/{}

# Try checking out again
dots checkout && echo "Checked out config." || echo "Failed to apply dotfiles."

# Hide untracked files
dots config --local status.showUntrackedFiles no

