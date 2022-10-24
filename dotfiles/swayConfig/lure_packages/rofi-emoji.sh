#!/bin/zsh
# vim: ft=sh
name="rofi-emoji"
_pkgname="$name"
_ver="3.1.0"
version="$_ver"
release=1
desc="A Rofi plugin for selecting emojis"
homepage="https://github.com/Mange/rofi-emoji"
architectures=("amd64")
license=("MIT")
provides=("$name=$_ver")
conflicts=("$name")

build_deps_fedora=("rofi-devel")
deps=("rofi")

sources=("https://github.com/Mange/${_pkgname}/archive/v${_ver}/${_pkgname}-${_ver}.tar.gz")
checksums=("SKIP")

build() {
    cd "$srcdir/$_pkgname-$_ver"
    autoreconf -i
    ./configure --prefix=/usr
    make
}

package() {
    cd "$srcdir/$_pkgname-$_ver"
    make DESTDIR="${pkgdir}/" install
    install -Dm 644 LICENSE -t "${pkgdir}/usr/share/licenses/${_pkgname}"
}
