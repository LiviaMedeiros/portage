# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.1

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="A logging system for WAI"
HOMEPAGE="https://hackage.haskell.org/package/wai-logger"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
IUSE=""

RESTRICT=test # does not specify full dependencies

RDEPEND="dev-haskell/byteorder:=[profile?]
	>=dev-haskell/fast-logger-3:=[profile?]
	dev-haskell/http-types:=[profile?]
	dev-haskell/network:=[profile?]
	>=dev-haskell/wai-2.0.0:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.10
	>=dev-haskell/cabal-doctest-1.0.6 <dev-haskell/cabal-doctest-1.1
	test? ( >=dev-haskell/doctest-0.10.1 )
"
