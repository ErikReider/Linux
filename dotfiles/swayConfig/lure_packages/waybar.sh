#!/bin/zsh
# vim: ft=sh
name="waybar-git"
_pkgname=Waybar
_ver="1.9.3"
version="$_ver-r636.67593b8"
release=1
desc="Highly customizable Wayland bar for Sway and Wlroots based compositors (GIT)"
homepage="https://github.com/Alexays/Waybar/"
architectures=("amd64")
license=("MIT")
provides=("waybar=$_ver")
conflicts=("waybar")

build_deps=("
    git"
    "meson"
    "cmake"
    "scdoc"
    "wayland-protocols"
    "upower"
    "bluez"
)
build_deps_fedora=(
    "git"
    "meson"
    "cmake"
    "scdoc"
    "wayland-protocols-devel"
    "gtk-layer-shell-devel"
    "gtkmm30-devel"
    "glib2-devel"
    "gobject-introspection-devel"
    "pulseaudio-libs-devel"
    "jsoncpp-devel"
    "libinput-devel"
    "libsigc++-devel"
    "fmt-devel"
    "wayland-devel"
    "date-devel"
    "spdlog-devel"
    "libnl3-devel"
    "libappindicator-gtk3-devel"
    "libdbusmenu-gtk3-devel"
    "libmpdclient-devel"
    "upower-devel"
    "bluez"
)

deps=("
    gtkmm3"
    "libjsoncpp.so"
    "libinput"
    "libsigc++"
    "fmt"
    "wayland"
    "chrono-date"
    "libspdlog.so"
    "gtk-layer-shell"
    "libpulse"
    "libnl"
    "libappindicator-gtk3"
    "libdbusmenu-gtk3"
    "libmpdclient"
    "upower"
    "bluez"
)
deps_fedora=(
    "gtkmm30"
    "jsoncpp"
    "libinput"
    "libsigc++"
    "fmt"
    "spdlog"
    "gtk-layer-shell"
    "pulseaudio-libs"
    "libnl3"
    "libappindicator-gtk3"
    "libdbusmenu-gtk3"
    "libmpdclient"
    "upower"
    "bluez"
)

sources=("git+https://github.com/Alexays/Waybar.git")
checksums=("SKIP")

version() {
    cd "$srcdir/$_pkgname"
    printf "$_ver-r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build() {
    cd "$srcdir"
    pwd
    meson setup --prefix /usr -Drfkill=enabled "$_pkgname" build
    meson compile -C build
}

package() {
    cd "$srcdir"
    DESTDIR="$pkgdir" meson install -C build
}
