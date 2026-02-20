#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "==> Setting up Ubuntu system"

# GNU Stow
if ! command -v stow &>/dev/null; then
    echo "==> Installing GNU Stow"
    apt-get update -qq
    apt-get install -y -qq stow
else
    echo "==> Stow already installed"
fi

# Stow dotfiles (helix, ghostty configs)
echo "==> Stowing configs"
mkdir -p ~/.config
cd "$DOTFILES_DIR"
stow --ignore='\.gitconfig' --ignore='\.zshrc' --ignore='hammerspoon' --ignore='iterm2' configs

# Symlink gitconfig
echo "==> Linking gitconfig"
ln -sf "$DOTFILES_DIR/configs/.config/.gitconfig" ~/.gitconfig

# Helix editor
if ! command -v hx &>/dev/null; then
    echo "==> Installing Helix editor"
    apt-get update
    apt-get install -y software-properties-common
    add-apt-repository -y ppa:maveonair/helix-editor
    apt-get update
    apt-get install -y helix
else
    echo "==> Helix already installed"
fi

# Zellij
if ! command -v zellij &>/dev/null; then
    echo "==> Installing Zellij"
    curl -sSL https://github.com/zellij-org/zellij/releases/latest/download/zellij-x86_64-unknown-linux-musl.tar.gz | tar xz -C /usr/local/bin
else
    echo "==> Zellij already installed"
fi

# Lazygit
if ! command -v lazygit &>/dev/null; then
    echo "==> Installing Lazygit"
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -sSLo /tmp/lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xzf /tmp/lazygit.tar.gz -C /usr/local/bin lazygit
    rm /tmp/lazygit.tar.gz
else
    echo "==> Lazygit already installed"
fi

# Starship prompt
if ! command -v starship &>/dev/null; then
    echo "==> Installing Starship"
    curl -sSL https://starship.rs/install.sh | sh -s -- -y
else
    echo "==> Starship already installed"
fi

# Add PATH entries to bashrc
if ! grep -q 'HOME/.local/bin' ~/.bashrc 2>/dev/null; then
    echo "==> Adding ~/.local/bin to PATH in .bashrc"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
else
    echo "==> ~/.local/bin PATH already in .bashrc"
fi

if ! grep -q 'HOME/go/bin' ~/.bashrc 2>/dev/null; then
    echo "==> Adding ~/go/bin to PATH in .bashrc"
    echo 'export PATH="$HOME/go/bin:$PATH"' >> ~/.bashrc
else
    echo "==> ~/go/bin PATH already in .bashrc"
fi

# Add IS_SANDBOX and claudeyolo alias to bashrc
if ! grep -q 'IS_SANDBOX' ~/.bashrc 2>/dev/null; then
    echo "==> Adding IS_SANDBOX to .bashrc"
    echo 'export IS_SANDBOX=1' >> ~/.bashrc
else
    echo "==> IS_SANDBOX already in .bashrc"
fi

if ! grep -q "alias claudeyolo=" ~/.bashrc 2>/dev/null; then
    echo "==> Adding claudeyolo alias to .bashrc"
    echo "alias claudeyolo='claude --dangerously-skip-permissions'" >> ~/.bashrc
else
    echo "==> cc alias already in .bashrc"
fi

# Add starship init to bashrc
if ! grep -q 'starship init bash' ~/.bashrc 2>/dev/null; then
    echo "==> Adding starship to .bashrc"
    echo 'eval "$(starship init bash)"' >> ~/.bashrc
else
    echo "==> Starship already configured in .bashrc"
fi

# fzf
if ! command -v fzf &>/dev/null; then
    echo "==> Installing fzf"
    apt-get install -y fzf
else
    echo "==> fzf already installed"
fi

# Hook fzf into bash
if ! grep -q "key-bindings.bash" ~/.bashrc 2>/dev/null; then
    echo "==> Adding fzf key bindings to .bashrc"
    cat >> ~/.bashrc <<'EOF'

# fzf key bindings and completion
source /usr/share/doc/fzf/examples/key-bindings.bash
EOF
else
    echo "==> fzf already configured in .bashrc"
fi

# gopls (Go language server)
if ! command -v gopls &>/dev/null && ! [ -x "$HOME/go/bin/gopls" ]; then
    echo "==> Installing gopls"
    go install golang.org/x/tools/gopls@latest
else
    echo "==> gopls already installed"
fi

# Git config
echo "==> Configuring git"
git config --global core.autocrlf input
git config --global core.editor hx

# Docker CE (via official script)
if ! command -v docker &>/dev/null || ! docker version --format '{{.Client.Version}}' 2>/dev/null | grep -q .; then
    echo "==> Installing Docker CE"
    apt-get remove -y docker.io docker-doc docker-compose podman-docker containerd runc 2>/dev/null || true
    curl -fsSL https://get.docker.com -o /tmp/get-docker.sh
    sh /tmp/get-docker.sh
    rm /tmp/get-docker.sh
else
    echo "==> Docker already installed"
fi

# Avahi (mDNS hostname advertising)
if ! dpkg -l avahi-daemon &>/dev/null; then
    echo "==> Installing avahi-daemon for mDNS"
    apt-get install -y avahi-daemon
else
    echo "==> avahi-daemon already installed"
fi
systemctl enable --now avahi-daemon

echo "==> Setup complete!"
