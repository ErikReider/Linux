#!/bin/bash

info() {
    echo $'\x1b[32m[INFO]\x1b[0m' "$@"
}

warn() {
    echo $'\x1b[31m[WARN]\x1b[0m' "$@"
}

error() {
    echo $'\x1b[31;1m[ERR]\x1b[0m' "$@"
    exit 1
}

installPkg() {
    rootCmd=""
    if command -v doas &>/dev/null; then
        rootCmd="doas"
    elif command -v sudo &>/dev/null; then
        rootCmd="sudo"
    else
        warn "No privilege elevation command (e.g. sudo, doas) detected"
    fi

    case $1 in
        pacman) $rootCmd pacman -U "${@:2}" ;;
        apk) $rootCmd apk add --allow-untrusted "${@:2}" ;;
        *) $rootCmd "$1" install "${@:2}" ;;
    esac
}

if command -v lure &>/dev/null; then
    info "Lure is already installed. Quitting..."
    exit 0
fi

if ! command -v curl &>/dev/null; then
    error "This script requires the curl command. Please install it and run again."
fi

pkgFormat=""
pkgMgr=""
if command -v pacman &>/dev/null; then
    info "Detected pacman"
    pkgFormat="pkg.tar.zst"
    pkgMgr="pacman"
elif command -v dnf &>/dev/null; then
    info "Detected dnf"
    pkgFormat="rpm"
    pkgMgr="dnf"
else
    error "No supported package manager detected!"
fi

latestVersion=$(curl -sI 'https://gitea.arsenm.dev/Arsen6331/lure/releases/latest' | grep -o 'location: .*' | rev | cut -d '/' -f1 | rev | tr -d '[:space:]')
info "Found latest LURE version:" "$latestVersion"

[ -d "/tmp/lure" ] || mkdir /tmp/lure
fname="/tmp/lure/lure-${latestVersion}.${pkgFormat}"
sum_fname="/tmp/lure/lure-${latestVersion}-checksums.txt"

if ! [ -f "$fname" ] || ! [ -f "$sum_fname" ]; then
    sum_url="https://gitea.arsenm.dev/Arsen6331/lure/releases/download/${latestVersion}/checksums.txt"
    info "Downloading LURE package"
    curl -L "$sum_url" -o "$sum_fname"

    url="https://gitea.arsenm.dev/Arsen6331/lure/releases/download/${latestVersion}/linux-user-repository-${latestVersion#v}-linux-$(uname -m).${pkgFormat}"
    info "Downloading LURE package"
    curl -L "$url" -o "$fname"
fi

# Validate
info "Validating Checksums..."
sha=$(sha256sum "$fname" | awk '{print $1}')
grep "$sha" "$sum_fname" &>/dev/null || {
    error "CHECKSUMS NOT MATCHING!"
    rm "$fname"
    rm "$sum_fname"
    exit 1
}

info "Installing LURE package"
installPkg "$pkgMgr" "$fname"

info "Cleaning up"
rm "$fname"
rm "$sum_fname"

info "Done!"
