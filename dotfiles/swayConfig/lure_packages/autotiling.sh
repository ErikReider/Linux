#!/bin/zsh
# vim: ft=sh
_pkgname=autotiling
name="$_pkgname-git"
_ver="1.6.1"
version="$_ver-r24.6854508"
release=1
desc="Script for sway and i3 to automatically switch the horizontal / vertical window split orientation"
homepage="https://github.com/nwg-piotr/autotiling"
architectures=("amd64")
license=("GPL3")
provides=("autotiling=$_ver")
conflicts=("autotiling")

build_deps=("git" "python-setuptools")
build_deps_fedora=("git" "python3-setuptools")
deps=("python-i3ipc")
deps_fedora=("python3-i3ipc")

sources=("git+https://github.com/nwg-piotr/autotiling.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

package() {
    cd "$srcdir/$_pkgname"
    python setup.py install --root="${pkgdir}" --optimize=1
}
