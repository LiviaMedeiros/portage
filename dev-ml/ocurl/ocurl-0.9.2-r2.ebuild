# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit dot-a findlib

DESCRIPTION="OCaml interface to the libcurl library"
HOMEPAGE="https://forge.ocamlcore.org/projects/ocurl/ https://github.com/ygrek/ocurl"
SRC_URI="https://github.com/ygrek/ocurl/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0/${PV}"
KEYWORDS="amd64 arm arm64 ~ppc ppc64 ~riscv x86"
IUSE="examples +ocamlopt"

RDEPEND="net-misc/curl
	dev-ml/lwt:=[ocamlopt?]
	dev-ml/ocplib-endian:=[ocamlopt?]"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	lto-guarantee-fat
	default
}

src_compile() {
	emake -j1 all
}

src_install() {
	findlib_src_install

	dodoc CHANGES.txt README.md

	if use examples; then
		dodoc -r examples
		docompress -x /usr/share/doc/${PF}/examples
	fi
	strip-lto-bytecode
}
