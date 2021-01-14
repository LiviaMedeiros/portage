# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit autotools desktop

DESCRIPTION="2D length scroll shooting game"
HOMEPAGE="http://triring.net/ps2linux/games/kxl/kxlgames.html"
SRC_URI="mirror://gentoo/${P}.tar.gz
	mirror://gentoo/${PN}.png"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="acct-group/gamestat
	dev-games/KXL"
RDEPEND="${DEPEND}
	media-fonts/font-adobe-100dpi"

PATCHES=(
	"${FILESDIR}"/${P}-paths.patch
)

src_prepare() {
	default
	rm -f missing
	sed -i \
		-e '1i #include <string.h>' \
		-e "s:DATA_PATH \"/.score\":\"/var/games/${PN}\":" \
		src/ranking.c || die
	sed -i -e '/CFLAGS/s/$/ @CFLAGS@/' src/Makefile.am || die #bug 426890
	mv configure.{in,ac}
	eautoreconf
}

src_install() {
	default

	insinto /var/games/${PN}
	newins data/.score ${PN}
	fowners root:gamestat /var/games/${PN} /usr/bin/geki3
	fperms 660 /var/games/${PN}
	fperms 2755 /usr/bin/geki3

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry geki3 Geki3
}
