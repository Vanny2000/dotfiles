# Dotfiles

Personal configuration files managed with GNU Stow.

## Prerequisites

### Core Tools (All Systems)

- Git
- GNU Stow
- Zsh
- Neovim
- Tmux
- Yazi (file manager)

### macOS Specific

- Sketchybar (status bar)
- Ghostty (terminal emulator)
- Aerospace (window manager)

## Installation of Prerequisites

### macOS

```bash
brew install stow git zsh neovim tmux yazi
brew tap FelixKratz/formulae
brew install sketchybar
# Install Ghostty and Aerospace from their respective websites
```

### Arch Linux

```bash
pacman -S stow git zsh neovim tmux yazi
```

### Debian/Ubuntu

```bash
sudo apt install stow git zsh neovim tmux
# Install yazi from source or other package managers
```

## Setup

1. Clone this repository:

```bash
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Stow configurations based on your system:

### For Arch Linux/Generic Linux

```bash
# Core configurations
stow zsh
stow nvim
stow tmux
stow yazi
```

### For macOS

```bash
# Core configurations
stow zsh
stow nvim
stow tmux
stow yazi

# macOS specific
stow sketchybar
stow aerospace
stow ghostty
```

## Configuration Overview

- `zsh/` - Shell configuration (all systems)
- `nvim/` - Neovim configuration (all systems)
- `tmux/` - Terminal multiplexer configuration (all systems)
- `yazi/` - File manager configuration (all systems)
- `sketchybar/` - Status bar configuration (macOS only)
- `aerospace/` - Window manager configuration (macOS only)
- `ghostty/` - Terminal emulator settings (macOS only)

## Notes

- Backup your existing configurations before stowing
- Only stow the configurations relevant to your system
- Use `stow -n <package>` to simulate stow operations
- Use `stow -D <package>` to unstow a package
