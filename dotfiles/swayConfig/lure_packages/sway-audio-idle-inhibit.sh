#!/bin/zsh
# vim: ft=sh
_pkgname=SwayAudioIdleInhibit
name="sway-audio-idle-inhibit-git"
_ver="0.1"
version="$_ver-r18.c582197"
release=1
desc="Prevents swayidle from sleeping while any application is outputting or receiving audio"
homepage="https://github.com/ErikReider/$_pkgname"
architectures=("amd64")
license=("GPL3")
provides=("sway-audio-idle-inhibit=$_ver")
conflicts=("sway-audio-idle-inhibit")

build_deps=("gcc" "meson" "git")
build_deps_fedora=("gcc" "meson" "git" "pulseaudio-libs-devel" "wayland-protocols-devel" "wayland-devel")

deps=("wayland" "wayland-protocols" "libpulse")
deps_fedora=("pulseaudio-libs")

sources=("git+https://github.com/ErikReider/$_pkgname.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "$srcdir"
    meson \
        --prefix /usr \
        "$_pkgname" build
    meson compile -C build
}

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" meson install -C build
}
