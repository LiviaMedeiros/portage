# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="OpenPGP keys used by Christian Göttsche (cgzones)"
HOMEPAGE="https://github.com/cgzones"
SRC_URI="
	https://github.com/cgzones.gpg -> ${P}.asc
"
S="${WORKDIR}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 sparc x86"

src_install() {
	local files=( ${A} )

	insinto /usr/share/openpgp-keys
	newins - cgzones.asc < <(cat "${files[@]/#/${DISTDIR}/}" || die)
}
