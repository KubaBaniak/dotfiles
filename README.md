## 01000100 01101111 01110100 01100110 01101001 01101100 01100101 01110011                                                                        

### Well these are my dotfiles using:
- Alacritty (terminal emulator)
- tmux
- neovim (btw)
- oh-my-zsh

Use at your own risk.

# Dotfiles

My configuration files (Neovim, Tmux, Zsh, Alacritty) managed via a bare Git repository.

## 🛠 Installation (New Machine)

To set up these dotfiles on a fresh machine, run the following commands in your terminal:

### 1. Clone & Setup

```bash
# 1. Clone the repo as a bare repository
git clone --bare https://github.com/KubaBaniak/dotfiles $HOME/.dotfiles

# 2. Define the alias locally for the current session
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 3. Checkout the content
dotfiles checkout

```

### 2. Handle Conflicting Files

If the checkout fails because default config files (like `.zshrc`) already exist, run this snippet to back them up and try again:

```bash
mkdir -p .dotfiles-backup && \
dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
xargs -I{} mv {} .dotfiles-backup/{}

# Retry checkout
dotfiles checkout

```

### 3. Final Configuration

Hide untracked files (so `dotfiles status` doesn't list every file in your home directory):

```bash
dotfiles config --local status.showUntrackedFiles no

```

---

## 🚀 Usage

Since this is a bare repo, use the `dotfiles` alias instead of `git`.

### The Alias

Ensure this is present in your `.zshrc` (it should be there after checkout):

```bash
alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

```

### Workflow

Manage your config files just like any Git repo:

```bash
# Check status
dotfiles status

# Add a specific file (e.g., after modifying nvim config)
dotfiles add .config/nvim/init.lua

# Add all changed tracked files
dotfiles add -u

# Commit changes
dotfiles commit -m "Update nvim colorscheme"

# Push to remote
dotfiles push

```

---

## 📂 Included Configurations

* **Zsh:** `.zshrc`
* **Tmux:** `.tmux.conf`
* **Neovim:** `.config/nvim/`
* **Alacritty:** `.config/alacritty/`
