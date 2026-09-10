## 01000100 01101111 01110100 01100110 01101001 01101100 01100101 01110011                                                                        

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

### 4. Bootstrap Environment (Plugins, TPM, Agentic Skills)

Run the included bootstrap script to install Oh My Zsh, custom Zsh plugins, Tmux Plugin Manager (TPM), and the **Superpowers** skills repository:

```bash
~/scripts/bootstrap.sh
```

---

## 🤖 AI & Agentic Coding (CodeCompanion + Superpowers)

This setup uses **CodeCompanion** paired with the **[Superpowers](https://github.com/obra/superpowers)** development methodology.

* **Methodology in Chat**: Enforces red-green TDD, Socratic brainstorming (`/brainstorm`), systematic debugging, and implementation plans.
* **External Skills Dependency**: Superpowers is an external repository that lives at `~/.config/nvim/skills/superpowers`. It is automatically cloned and kept up-to-date by `~/scripts/bootstrap.sh`.
* **Manual clone / update**:
  ```bash
  # Initial clone (if not using bootstrap.sh)
  git clone https://github.com/obra/superpowers.git ~/.config/nvim/skills/superpowers

  # Update anytime
  git -C ~/.config/nvim/skills/superpowers pull
  ```

> **Note:** Without this repo present at `~/.config/nvim/skills/superpowers`, Neovim will still function normally with default rules, but automated skill invocations (`brainstorming`, `writing-plans`, `tdd`, etc.) will not find their definition files.

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

* **Zsh:** `.zshrc` (with custom Oh My Zsh plugins)
* **Tmux:** `.tmux.conf` (TPM-managed)
* **Neovim:** `.config/nvim/` (CodeCompanion, LSP, Treesitter)
* **Alacritty:** `.config/alacritty/`
* **Bootstrap Script:** `scripts/bootstrap.sh`
