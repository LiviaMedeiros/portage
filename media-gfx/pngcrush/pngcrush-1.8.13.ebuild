# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Portable Network Graphics (PNG) optimizing utility"
HOMEPAGE="https://pmt.sourceforge.io/pngcrush/"
SRC_URI="system-libs? ( mirror://sourceforge/pmt/${P}-nolib.tar.xz )
	!system-libs? ( mirror://sourceforge/pmt/${P}.tar.xz )"

LICENSE="pngcrush"
SLOT="0"
KEYWORDS="~alpha amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="+system-libs"

RDEPEND="
	system-libs? (
		media-libs/libpng:0=
		sys-libs/zlib:=
	)"
DEPEND="${RDEPEND}
	app-arch/xz-utils"

pkg_setup() {
	use system-libs && S+="-nolib"
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		LD="$(tc-getCC)" \
		CFLAGS="${CFLAGS} ${CPPFLAGS} -Wall" \
		LDFLAGS="${LDFLAGS}"
}

src_install() {
	dobin ${PN}
	dodoc ChangeLog.html
}
