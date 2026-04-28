#!/usr/bin/env bash
set -euo pipefail

yay_packages=(
    asdf-vm
    asn-git
    aws-cli
    balena-etcher
    cargo-audit
    cargo-expand
    cargo-flamegraph
    cargo-llvm-cov
    cargo-machete
    cargo-nextest
    cinny-desktop-bin
    claude-agent-acp
    claude-code
    cmake
    filelight
    flatpak
    freecad
    ghidra
    gimp
    halloy
    htop
    imhex
    informant
    jq
    kamoso
    kcharselect
    kicad
    kicad-library
    kicad-library-3d
    krdc
    krfb
    ktorrent
    mariadb-clients
    mold
    mqttx-bin
    neovim
    nmap
    onlyoffice-bin
    opentofu
    plasma-weather-plus
    plasma6-applets-plasmusic-toolbar
    plasma6-applets-resources-monitor
    podman
    podman-compose
    podman-desktop
    postgresql-libs
    rclone
    scaleway-cli
    sdrangel-bin
    sdrconnect
    starship
    steam
    tcpdump
    tealdeer
    tmux
    tokei
    tree
    tree-sitter-cli
    ttf-jetbrains-mono-nerd
    tuba
    uv
    valgrind
    wireshark-cli
    wireshark-qt
    xclip
    yq
    zoxide
    zsh
)

flatpak_packages=(
    com.discordapp.Discord
    com.protonvpn.www
    com.slack.Slack
    com.spotify.Client
    com.ultimaker.cura
    me.proton.Pass
    net.runelite.RuneLite
)

echo "Ranking mirrors..."
sudo eos-rankmirrors
sudo cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak
sudo reflector --protocol https --age 12 --sort rate --country Sweden,Finland,Denmark,Norway,Germany --save /etc/pacman.d/mirrorlist

echo "Updating packages..."
eos-update --aur

echo "Installing pacman & AUR packages..."
yay -S --needed --noconfirm "${yay_packages[@]}"

echo "Installing Flatpak packages..."
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
    ssh-keygen -t ed25519 -C "emanuel.claesson@gmail.com" -f ~/.ssh/id_ed25519
    ssh-add ~/.ssh/id_ed25519
fi

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
