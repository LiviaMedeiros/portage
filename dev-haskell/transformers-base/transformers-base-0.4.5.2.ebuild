# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# ebuild generated by hackport 0.5.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour"
inherit haskell-cabal

DESCRIPTION="Lift computations from the bottom of a transformer stack"
HOMEPAGE="https://github.com/mvv/transformers-base"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86 ~amd64-linux"
IUSE="+orphaninstances"

RDEPEND=">=dev-haskell/stm-2.3:=[profile?]
	>=dev-haskell/transformers-compat-0.6.1:=[profile?]
	>=dev-lang/ghc-7.8.2:=
	orphaninstances? ( >=dev-haskell/base-orphans-0.3:=[profile?] )
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.18.1.3
"

src_configure() {
	haskell-cabal_src_configure \
		$(cabal_flag orphaninstances orphaninstances)
}
