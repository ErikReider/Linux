#!/bin/bash

latestVersion="3.7.5"
channel="stable"
sha="01cad642beb492e8af8413331b50325e1430b934df7be89aa9a29ea2de8df8f0"
destination="$HOME"

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

if command -v flutter &>/dev/null; then
    info "Flutter is already installed. Quitting..."
    exit 0
fi

[ -d "/tmp/flutter" ] || mkdir /tmp/flutter
fname="/tmp/flutter/flutter-${latestVersion}-${channel}.tar.gz"

if ! [ -f "$fname" ]; then
    url="https://storage.googleapis.com/flutter_infra_release/releases/${channel}/linux/flutter_linux_${latestVersion}-${channel}.tar.xz"
    info "Downloading Flutter archive"
    curl -L "$url" -o "$fname"
fi

# Validate
info "Validating Checksums..."
if ! [ "$(sha256sum "$fname" | awk '{print $1}')" == "$sha" ]; then
    error "CHECKSUMS NOT MATCHING!"
    rm "$fname"
    exit 1
fi

info "Extracting Flutter SDK..."
tar -xf "$fname" -C "$destination"

info "Cleaning up"
rm "$fname"

info "Done!"
