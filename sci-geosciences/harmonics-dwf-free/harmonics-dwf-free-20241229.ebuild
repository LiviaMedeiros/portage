# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_P="${P/-free-/-}"
DESCRIPTION="Tidal harmonics database for libtcd"
HOMEPAGE="https://flaterco.com/xtide/"
SRC_URI="https://flaterco.com/files/xtide/${MY_P}-free.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~x86"

src_install() {
	insinto /usr/share/harmonics
	doins "${MY_P}"-free.tcd
	dodoc ChangeLog
}
