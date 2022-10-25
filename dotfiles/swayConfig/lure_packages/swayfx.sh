#!/bin/zsh
# vim: ft=sh
name="swayfx-git"
_pkgname=swayfx
_ver="1.7"
version="$_ver-r6885.2289f452"
release=1
desc="i3-compatible window manager for Wayland"
homepage="https://github.com/WillPower3309/swayfx"
architectures=("amd64")
license=("MIT")
provides=("sway=$_ver")
conflicts=("sway")

build_deps=("git" "meson" "scdoc" "wayland-protocols")
build_deps_fedora=("git" "meson" "scdoc" "wayland-protocols-devel")

deps=("cairo" "gdk-pixbuf2" "json-c" "pango" "polkit" "pcre2" "swaybg" "ttf-font" "wlroots" "xorg-server-xwayland")
deps_fedora=("cairo-devel" "gdk-pixbuf2-devel" "json-c-devel" "pango-devel" "polkit-devel" "pcre2-devel" "swaybg" "wlroots-devel" "xorg-x11-server-Xwayland-devel")

sources=("git+https://github.com/WillPower3309/swayfx.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    meson \
        --prefix /usr \
        -Dsd-bus-provider=libsystemd \
        -Dwerror=false \
        "$_pkgname" build
    meson compile -C build
}

package() {
    install -Dm644 50-systemd-user.conf -t "$pkgdir/etc/sway/config.d/"

    DESTDIR="$pkgdir" meson install -C build

    cd "$_pkgname"
    install -Dm644 "LICENSE" "$pkgdir/usr/share/licenses/$_pkgname/LICENSE"
    for util in autoname-workspaces.py inactive-windows-transparency.py grimshot; do
        install -Dm755 "contrib/$util" -t "$pkgdir/usr/share/$_pkgname/scripts"
    done
}
