# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

MY_P="${P/fil/FIL}"

DESCRIPTION="FIL-plugins ladspa plugin package. Filters by Fons Adriaensen"
HOMEPAGE="http://kokkinizita.linuxaudio.org/linuxaudio/"
SRC_URI="http://kokkinizita.linuxaudio.org/linuxaudio/downloads/${MY_P}.tar.bz2"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"

DEPEND="media-libs/ladspa-sdk"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-makefile.patch
)

src_compile() {
	emake CXX="$(tc-getCXX)"
}

src_install() {
	dodoc AUTHORS README
	insinto /usr/$(get_libdir)/ladspa
	insopts -m0755
	doins *.so
}
