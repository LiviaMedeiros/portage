# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.7.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="The Bifunctors package authored by Edward Kmett"
HOMEPAGE="https://github.com/ekmett/bifunctors/"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE="+semigroups +tagged"

RDEPEND=">=dev-haskell/base-orphans-0.8.4:=[profile?] <dev-haskell/base-orphans-1:=[profile?]
	>=dev-haskell/comonad-5.0.7:=[profile?] <dev-haskell/comonad-6:=[profile?]
	>=dev-haskell/th-abstraction-0.4.2.0:=[profile?] <dev-haskell/th-abstraction-0.5:=[profile?]
	>=dev-lang/ghc-8.4.3:=
	tagged? ( >=dev-haskell/tagged-0.8.6:=[profile?] <dev-haskell/tagged-1:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-2.2.0.1
	test? ( >=dev-haskell/hspec-1.8
		>=dev-haskell/quickcheck-2 <dev-haskell/quickcheck-3
		dev-haskell/transformers-compat )
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag semigroups semigroups) \
		$(cabal_flag tagged tagged)
}
