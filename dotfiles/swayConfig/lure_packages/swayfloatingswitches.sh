#!/bin/zsh
# vim: ft=sh
_pkgname=swayfloatingswitcher
_pkgfoldername=SwayFloatingSwitcher
name="$_pkgname-git"
_ver="0.2.0"
version="$_ver-r6.1e792be"
release=1
desc="A simple Alt+Tab switcher for floating windows"
homepage="https://github.com/ErikReider/$_pkgname"
architectures=("amd64")
license=("GPL3")
provides=("$_pkgname=$_ver")
conflicts=("$_pkgname")

build_deps=("git" "meson" "scdoc" "vala")
build_deps_fedora=("git" "meson" "vala" "gtk-layer-shell-devel" "libhandy-devel" "gtk3-devel" "glib2-devel" "libgee-devel" "gobject-introspection-devel" "json-glib-devel" "granite-devel")

deps=("gtk3" "gtk-layer-shell" "glib2" "gobject-introspection" "libgee" "json-glib" "granite" "gtk-layer-shell")
deps_fedora=("gtk-layer-shell" "gtk3" "glib2")

sources=("git+https://github.com/ErikReider/$_pkgname.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    ls $srcdir
    cd "$srcdir"
    meson setup --prefix /usr "$_pkgname" build
    meson compile -C build
}

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" meson install -C build
}
