#!/bin/zsh
# vim: ft=sh
name="swaysettings-git"
_pkgname=swaysettings
_ver="0.4.0"
version="$_ver-r185.c3bb640"
release=1
desc="A gui for setting sway wallpaper, default apps, GTK themes, etc..."
homepage="https://github.com/ErikReider/swaysettings"
architectures=("amd64")
license=("GPL3")
provides=("swaysettings=$_ver")
conflicts=("swaysettings")

build_deps=("git" "meson" "scdoc" "vala")
build_deps_fedora=("git" "meson" "vala" "gtk-layer-shell-devel" "libhandy-devel" "gtk3-devel" "glib2-devel" "libgee-devel" "gobject-introspection-devel" "json-glib-devel" "granite-devel" "libxml2-devel" "accountsservice-devel" "pulseaudio-libs-devel")

deps=("gtk3" "gtk-layer-shell" "libhandy" "glib2" "gobject-introspection" "libgee" "json-glib" "granite" "libxml2" "xkeyboard-config" "accountsservice" "gtk-layer-shell" "libpulse" "bluez")
deps_fedora=("accountsservice" "gtk-layer-shell" "bluez" "pulseaudio-libs" "gtk3" "glib2")

sources=("git+https://github.com/ErikReider/swaysettings.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "$srcdir"
    meson setup --prefix /usr "$_pkgname" build
    meson compile -C build
}

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" meson install -C build
}
