#!/usr/bin/env bash
set -euo pipefail

echo "=================================================="
echo "        Bootstrapping Dotfiles Environment        "
echo "=================================================="

clone_or_update() {
  local repo_url="$1"
  local target_dir="$2"
  local name="$3"

  if [ ! -d "$target_dir" ]; then
    echo "==> Cloning $name into $target_dir..."
    mkdir -p "$(dirname "$target_dir")"
    git clone "$repo_url" "$target_dir"
  else
    echo "==> $name already installed at $target_dir. Updating..."
    git -C "$target_dir" pull --ff-only || echo "Warning: failed to fast-forward $name, skipping."
  fi
}

# 1. Bare Dotfiles Repository Config
if [ -d "$HOME/.dotfiles" ]; then
  echo "==> Configuring bare dotfiles repository (hide untracked)..."
  /usr/bin/git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" config --local status.showUntrackedFiles no
fi

# 2. Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "==> Installing Oh My Zsh (unattended, keeping existing .zshrc)..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended --keep-zshrc
else
  echo "==> Oh My Zsh is already installed."
fi

# 3. Zsh Custom Plugins
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
clone_or_update "https://github.com/zsh-users/zsh-autosuggestions" \
  "$ZSH_CUSTOM/plugins/zsh-autosuggestions" \
  "zsh-autosuggestions"

clone_or_update "https://github.com/zsh-users/zsh-syntax-highlighting.git" \
  "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" \
  "zsh-syntax-highlighting"

clone_or_update "https://github.com/zdharma-continuum/fast-syntax-highlighting.git" \
  "$ZSH_CUSTOM/plugins/fast-syntax-highlighting" \
  "fast-syntax-highlighting"

clone_or_update "https://github.com/marlonrichert/zsh-autocomplete.git" \
  "$ZSH_CUSTOM/plugins/zsh-autocomplete" \
  "zsh-autocomplete"

# 4. Tmux Plugin Manager (TPM)
clone_or_update "https://github.com/tmux-plugins/tpm" \
  "$HOME/.tmux/plugins/tpm" \
  "Tmux Plugin Manager (TPM)"

# 5. Superpowers Skills (Required for CodeCompanion Agentic Workflows)
clone_or_update "https://github.com/obra/superpowers.git" \
  "$HOME/.config/nvim/skills/superpowers" \
  "Superpowers Skills for CodeCompanion"

# 6. Verify System Tools
echo ""
echo "==> Checking required system tools:"
for tool in git zsh tmux nvim curl; do
  if command -v "$tool" >/dev/null 2>&1; then
    version=""
    case "$tool" in
      nvim) version=" ($("$tool" --version | head -n 1))" ;;
      tmux) version=" ($("$tool" -V))" ;;
      zsh)  version=" ($("$tool" --version))" ;;
      git)  version=" ($("$tool" --version))" ;;
      curl) version=" ($("$tool" --version | head -n 1 | awk '{print $1, $2}'))" ;;
    esac
    echo "  ✓ $tool$version"
  else
    echo "  ✗ $tool is NOT installed - please install via your package manager"
  fi
done

echo ""
echo "=================================================="
echo "          Bootstrap Complete!                     "
echo "  Restart your shell or run: source ~/.zshrc      "
echo "=================================================="
