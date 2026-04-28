#!/usr/bin/env bash
set -euo pipefail

# TODO: RClone config. NPM packages.

name="Emanuel Claesson"
email="emanuel.claesson@gmail.com"
editor="nvim"

yay_packages=(
    tree
    htop
    jq
    zsh
    tealdeer
    uv
    neovim
    tmux
    ktorrent
    kcharselect
    filelight
    kamoso
    halloy
    tokei
    rclone
    zoxide
    tcpdump
    yq
    postgresql-libs
    mariadb-clients
    nmap
    wireshark-cli
    wireshark-qt
    ghidra
    imhex
    opentofu
    valgrind
    cmake
    gimp
    freecad
    kicad
    kicad-library
    kicad-library-3d
    ttf-jetbrains-mono-nerd
    flatpak
    podman
    podman-desktop
    podman-compose
    steam
    xclip
    tree-sitter-cli
    krdc
    krfb
    asdf-vm
    asn-git
    sdrconnect
    balena-etcher
    claude-code
    onlyoffice-bin
    mqttx-bin
    sdrangel-bin
    informant
    mold
    cargo-expand
    cargo-audit
    cargo-machete
    cargo-nextest
    cargo-llvm-cov
    cargo-flamegraph
    scaleway-cli
    aws-cli
    starship
    claude-agent-acp
    chezmoi
    plasma-weather-plus
    plasma6-applets-resources-monitor
    plasma6-applets-plasmusic-toolbar
    cinny-desktop-bin
    tuba
)

flatpak_packages=(
    com.spotify.Client
    com.slack.Slack
    com.discordapp.Discord
    net.runelite.RuneLite
    com.ultimaker.cura
    me.proton.Pass
    com.protonvpn.www
)

echo "Ranking mirrors..."
sudo eos-rankmirrors
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --protocol https --age 12 --sort rate --country Sweden,Finland,Denmark,Norway,Germany --save /etc/pacman.d/mirrorlist

echo "Updating packages..."
eos-update --aur

echo "Installing pacman & AUR packages..."
yay -S --needed --noconfirm "${yay_packages[@]}"

echo "Installing flatpak packages..."
flatpak install -y "${flatpak_packages[@]}"

echo "Setting up zsh..."
if [[ "$SHELL" != "$(which zsh)" ]]; then
    chsh -s "$(which zsh)"
fi

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    KEEP_ZSHRC=yes RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting

echo "Setting up asdf..."
declare -A asdf_urls=(
    [nodejs]="https://github.com/asdf-vm/asdf-nodejs.git"
    [erlang]="https://github.com/asdf-vm/asdf-erlang.git"
    [elixir]="https://github.com/asdf-vm/asdf-elixir.git"
    [java]="https://github.com/halcyon/asdf-java.git"
    [golang]="https://github.com/asdf-community/asdf-golang.git"
    [rust]="https://github.com/code-lever/asdf-rust.git"
)

declare -A asdf_versions=(
    [java]="temurin-25"
)

for tool in "${!asdf_urls[@]}"; do
    if ! asdf plugin list 2>/dev/null | grep -q "^${tool}$"; then
        asdf plugin add "${tool}" "${asdf_urls[$tool]}"
    fi

    resolved="$(asdf latest "${tool}" "${asdf_versions[$tool]:-}" 2>/dev/null || asdf latest "${tool}")"

    if ! asdf list "${tool}" 2>/dev/null | grep -q "${resolved}"; then
        asdf install "${tool}" "${resolved}"
    fi
    asdf set -u "${tool}" "${resolved}"
done

for component in rust-analyzer rust-src llvm-tools-preview; do
    if ! rustup component list --installed 2>/dev/null | grep -q "^${component}"; then
        echo "  Installing rust component: ${component}"
        rustup component add "${component}"
    fi
done
asdf reshim rust

echo "Setting up SSH..."
systemctl --user enable --now ssh-agent.socket
if [[ ! -f ~/.ssh/id_ed25519 ]]; then
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"
    ssh-keygen -t ed25519 -C "${email}" -f ~/.ssh/id_ed25519
    ssh-add ~/.ssh/id_ed25519
fi

echo "Setting up Git..."
git config --global user.name "${name}"
git config --global user.email "${email}"
git config --global core.editor "${editor}"
git config --global init.defaultBranch "main"
git config --global push.autoSetupRemote true
git config --global core.fsmonitor true
git config --global diff.algorithm histogram

echo "Misc setup..."
tldr --update

sudo mkdir -p /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/99-retention.conf > /dev/null <<EOF
[Journal]
MaxRetentionSec=30day
SystemMaxUse=500M
EOF


echo "Setting up Claude Code..."
claude auth login
claude setup-token

echo "Manual setup"
echo " * Put Claude Code token in ~./claude_code_token"
echo " * Add ssh key to Github & Servers"
echo " * Sign in to Firefox profile"

echo "Done!"
