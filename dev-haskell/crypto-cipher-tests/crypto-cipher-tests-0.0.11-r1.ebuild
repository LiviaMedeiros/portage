# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# ebuild generated by hackport 0.6.6.9999

CABAL_FEATURES="lib profile haddock hoogle hscolour test-suite"
inherit haskell-cabal

DESCRIPTION="Generic cryptography cipher tests"
HOMEPAGE="https://github.com/vincenthz/hs-crypto-cipher"
SRC_URI="https://hackage.haskell.org/package/${P}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0/${PV}"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE=""

RDEPEND=">=dev-haskell/byteable-0.1.1:=[profile?] <dev-haskell/byteable-0.2:=[profile?]
	>=dev-haskell/crypto-cipher-types-0.0.8:=[profile?] <dev-haskell/crypto-cipher-types-0.1:=[profile?]
	dev-haskell/hunit:=[profile?]
	dev-haskell/mtl:=[profile?]
	>=dev-haskell/quickcheck-2:2=[profile?]
	>=dev-haskell/securemem-0.1.1:=[profile?] <dev-haskell/securemem-0.2:=[profile?]
	dev-haskell/test-framework:=[profile?]
	dev-haskell/test-framework-hunit:=[profile?]
	dev-haskell/test-framework-quickcheck2:=[profile?]
	>=dev-lang/ghc-7.4.1:=
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.8
"
