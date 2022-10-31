#!/bin/zsh
# vim: ft=sh
_pkgname=swaylock-effects
name="$_pkgname-erikreider-git"
_ver="1.6.10"
version="$_ver-r241.b3a375a"
release=1
desc="A fancier screen locker for Wayland."
homepage="https://github.com/ErikReider/swaylock-effects"
architectures=("amd64")
license=("MIT")
provides=("swaylock=$_ver" "swaylock-effects=$_ver")
conflicts=("swaylock")

build_deps=("git" "meson" "scdoc" "wayland-protocols")
build_deps_fedora=("git" "meson" "scdoc" "wayland-protocols-devel")

deps=("libxkbcommon" "cairo" "gdk-pixbuf2" "pam")
deps_fedora=("libxkbcommon-devel" "cairo-devel" "gdk-pixbuf2-devel" "pam-devel")

sources=("git+https://github.com/ErikReider/swaylock-effects.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    meson setup --prefix /usr "$_pkgname" build
    meson compile -C build
}

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" ninja -C build install
    chmod a+s "$pkgdir/usr/bin/swaylock"
}
