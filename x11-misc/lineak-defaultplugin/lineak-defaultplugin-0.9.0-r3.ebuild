# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P=${P/.0/}

DESCRIPTION="Mute/unmute and other macros for LINEAK"
HOMEPAGE="https://lineak.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/lineak/${MY_P}.tar.gz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ppc x86"
IUSE="debug"

RDEPEND="=x11-misc/lineakd-${PV}*"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto
"

DOCS=( AUTHORS README )

PATCHES=(
	"${FILESDIR}"/${P}-gcc43.patch
	"${FILESDIR}"/${P}-gcc47.patch
	"${FILESDIR}"/${P}-configure-clang16.patch
)

src_prepare() {
	default

	sed -i -e 's:$(DESTDIR)${DESTDIR}:$(DESTDIR):' default_plugin/Makefile.in || die
}

src_configure() {
	econf \
		$(use_enable debug) \
		--with-lineak-plugindir="${EPREFIX}/usr/$(get_libdir)/lineakd" \
		USER_LDFLAGS="${LDFLAGS}"
}
