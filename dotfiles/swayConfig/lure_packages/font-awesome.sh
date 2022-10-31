#!/bin/zsh
# vim: ft=sh
name="font-awesome"
version="6.2.0"
_pkgFolderName="Font-Awesome-$version"
release=1
desc="Iconic font designed for Bootstrap"
homepage="https://fontawesome.com/"
architectures=("amd64")
license=('custom:OFL')
provides=(
    "ttf-$name=$_ver"
    "otf-$name=$_ver"
)
conflicts=("$name")

# sources=("git+https://github.com/Alexays/Waybar.git")
sources=("https://github.com/FortAwesome/Font-Awesome/archive/$version.tar.gz")
checksums=('bebe89d335d55c021c5d3c11212f69849b540950a0eb79e6e3bdcf7e041b98e2')

package() {
    cd "$srcdir/$_pkgFolderName"

    install -Dm644 LICENSE.txt "$pkgdir/usr/share/licenses/$pkgname/LICENSE.txt"

    # ttf
    install -d "$pkgdir/usr/share/fonts/TTF"
    install -m644 ./webfonts/*.ttf "$pkgdir/usr/share/fonts/TTF"

    # otf
    install -d "$pkgdir/usr/share/fonts/OTF"
    install -m644 ./otfs/*.otf "$pkgdir/usr/share/fonts/OTF"
}
