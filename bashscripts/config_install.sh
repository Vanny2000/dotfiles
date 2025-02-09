#!/bin/bash
git clone --bare https://github.com/Vanny2000/dotfiles.git $HOME/dotfiles
function dots {
   /usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME $@
}
mkdir -p .config-backup
dots checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
fi;
dots checkout
dots config status.showUntrackedFiles no
