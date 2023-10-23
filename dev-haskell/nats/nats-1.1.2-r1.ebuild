# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.6.7.9999

CABAL_FEATURES="lib profile"
# break circular dependencies:
# https://github.com/gentoo-haskell/gentoo-haskell/issues/810
CABAL_FEATURES+=" nocabaldep"
inherit haskell-cabal

DESCRIPTION="Natural numbers"
HOMEPAGE="https://github.com/ekmett/nats/"
SRC_URI="
	https://hackage.haskell.org/package/${P}/${P}.tar.gz
	https://hackage.haskell.org/package/${P}/revision/3.cabal -> ${PF}.cabal"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+binary +hashable +template-haskell"

RDEPEND=">=dev-lang/ghc-7.4.1:=
	hashable? ( >=dev-haskell/hashable-1.1.2.0:=[profile?] )
"
DEPEND="${RDEPEND}"

src_prepare() {
	default

	cp "${DISTDIR}/${PF}.cabal" "${S}/${PN}.cabal" || die
}

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag binary binary) \
		$(cabal_flag hashable hashable) \
		$(cabal_flag template-haskell template-haskell)
}
